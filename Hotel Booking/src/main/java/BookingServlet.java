

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	Connection con;
	
	public void init() throws ServletException{
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con=DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel","root","");
		}
		catch(Exception e) {
			e.printStackTrace();
			
		}
	}

    public BookingServlet() {
        super();  
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
		PrintWriter out=response.getWriter();
		
		String action=request.getParameter("action");
		
		String id=request.getParameter("id");
		String name=request.getParameter("name");
		String phone=request.getParameter("phone");
		String mail=request.getParameter("mail");
		String room=request.getParameter("room");
		String days=request.getParameter("days");
		
		int amount=0;
		
		try {
			if(name==null || name.trim().equals("")) {
				out.println("Name Cannot be empty");
				return;
			}
			if(phone==null || !phone.matches("\\d{10}")) {
				out.println("Enter Valid 10 Digit Phone Number");
				return;
			}
			if(mail==null || mail.length()==0 || !mail.matches("[a-zA-Z0-9.-_]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}+") ) {
				out.println("<script>alert('Enter Valid Email');window.location='Index.jsp';</script>");
				return;
			}
			if(room==null || room.equals("")) {
				out.println("<script>alert('Enter Room Type');window.location='Index.jsp';</script>");
				return;
			}
			int d=0;
			try {
				d=Integer.parseInt(days);
				if(d<=0) {
					out.println("Days must be greater than 0");
					return;
				}
			}catch(Exception e) {
				out.println("Invalid number of days");
				return;
			}
			
			if(("Update".equals(action) || "Delete".equals(action)) && (id == null || id.equals(""))) {
				out.println("<script>alert('Booking Id Required');window.location='Index.jsp';</script>");
				return;
			}
			if(room!=null && days!=null && !room.equals("")) {
				
				if(room.equals("Deluxe"))
					amount=d*2000;
				if(room.equals("Suite"))
					amount=d*3500;
				if(room.equals("Standard"))
					amount=d*1200;
			}
			PreparedStatement ps;
			
			if("Insert".equals(action))
			{
				ps=con.prepareStatement("insert into booking values(?,?,?,?,?,?,?)");
				ps.setInt(1, Integer.parseInt(id));
				ps.setString(2, name);
				ps.setString(3, phone);
				ps.setString(4, mail);
				ps.setString(5, room);
				ps.setInt(6, Integer.parseInt(days));
				ps.setInt(7, amount);
				
				ps.executeUpdate();
				
						out.println("Inserted Successfully");
				
			}
			else if("Update".equals(action)) {
				ps=con.prepareStatement("update booking set name=?,phone=?,mail=?,room_type=?,days=?,amount=? where booking_id=?");
				ps.setString(1, name);
				ps.setString(2, phone);
				ps.setString(3, mail);
				ps.setString(4, room);
				ps.setInt(5,Integer.parseInt(days));
				ps.setInt(6, amount); 
				ps.setInt(7, Integer.parseInt(id));
				
				ps.executeUpdate();
				out.println("Updated Successfully");
			}
			else if("Delete".equals(action)) {
				ps=con.prepareStatement("delete from booking where booking_id=?");
				ps.setInt(1, Integer.parseInt(id));
				
				int row=ps.executeUpdate();
				if(row>0) {
					out.println("Deleted Successfully");
				}else {
					out.println("Booking ID not found");
				}
				
			}
			else if("Display".equals(action)) {
				Statement st=con.createStatement();
				ResultSet rs=st.executeQuery("Select * From booking") ;
				
				out.println("<table border=1>");
				out.println("<tr>");
				out.println("<th>ID</th>");
				out.println("<th>Name</th>");
				out.println("<th>Phone</th>");
				out.println("<th>Email</th>");
				out.println("<th>Room</th>");
				out.println("<th>Days</th>");
				out.println("<th>Amount</th>");
				out.println("</tr>");
				
				while(rs.next())
				{
					out.println("<tr>");
					out.println("<td>"+rs.getInt(1)+"</td>");
					out.println("<td>"+rs.getString(2)+"</td>");
					out.println("<td>"+rs.getString(3)+"</td>");
					out.println("<td>"+rs.getString(4)+"</td>");
					out.println("<td>"+rs.getString(5)+"</td>");
					out.println("<td>"+rs.getInt(6)+"</td>");
					out.println("<td>"+rs.getInt(7)+"</td>");
					out.println("</tr>");
				}
				out.println("</table>");
			}
		}
		catch (Exception e) {
			out.println(e);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
