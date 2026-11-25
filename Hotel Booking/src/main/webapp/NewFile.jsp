<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hotel Room Booking</title>
</head>

<body>

<h2 align="center">Hotel Room Booking System</h2>

<form method="post">
Booking Id : <input type="text" name="id"/><br><br>
Customer Name : <input type="text" name="name"/><br><br>
Phone Number : <input type="text" name="phone"/><br><br>
Email ID : <input type="text" name="mail"/><br><br>

Room Type :
<select name="room">
<option value="">Select</option>
<option value="Deluxe">Deluxe</option>
<option value="Suite">Suite</option>
<option value="Standard">Standard</option>
</select>

<br><br>

Number Of Days : <input type="text" name="days"><br><br>

<input type="submit" name="action" value="Insert"/>
<input type="submit" name="action" value="Update"/>
<input type="submit" name="action" value="Delete"/>
<input type="submit" name="action" value="Display"/>

</form>

<%
String action=request.getParameter("action");

if(action!=null)
{

String id=request.getParameter("id");
String name=request.getParameter("name");
String phone=request.getParameter("phone");
String mail=request.getParameter("mail");
String room=request.getParameter("room");
String days=request.getParameter("days");

int amount=0;

Connection con=null;

try{

Class.forName("com.mysql.jdbc.Driver");
con=DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel","root","");

if("Insert".equals(action) || "Update".equals(action))
{
if(id==null || id.equals("")){
	out.println("ID cannot be empty");
	return;
}

if(name==null || name.trim().equals(""))
{
out.println("Name cannot be empty");
return;
}

if(phone==null || !phone.matches("\\d{10}"))
{
out.println("Enter valid 10 digit phone number");
return;
}

if(mail==null || mail.length()==0 || !mail.matches("[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}"))
{
out.println("Enter valid email");
return;
}

if(room==null || room.equals(""))
{
out.println("Select room type");
return;
}

int d=0;

try{
d=Integer.parseInt(days);

if(d<=0)
{
out.println("Days must be greater than 0");
return;
}

}catch(Exception e){
out.println("Invalid days");
return;
}

if(("Update".equals(action) || "Delete".equals(action)) && (id==null || id.equals("")))
{
out.println("Booking ID required");
return;
}

if(room.equals("Deluxe"))
amount=d*2000;

if(room.equals("Suite"))
amount=d*3500;

if(room.equals("Standard"))
amount=d*1200;

PreparedStatement ps;

if("Insert".equals(action))
{

ps=con.prepareStatement("insert into booking values(?,?,?,?,?,?,?)");

ps.setInt(1,Integer.parseInt(id));
ps.setString(2,name);
ps.setString(3,phone);
ps.setString(4,mail);
ps.setString(5,room);
ps.setInt(6,d);
ps.setInt(7,amount);

ps.executeUpdate();

out.println("Inserted Successfully");

}

else if("Update".equals(action))
{

ps=con.prepareStatement("update booking set name=?,phone=?,mail=?,room_type=?,days=?,amount=? where booking_id=?");

ps.setString(1,name);
ps.setString(2,phone);
ps.setString(3,mail);
ps.setString(4,room);
ps.setInt(5,d);
ps.setInt(6,amount);
ps.setInt(7,Integer.parseInt(id));

int row=ps.executeUpdate();

if(row>0)
out.println("Updated Successfully");
else
out.println("Booking ID not found");

}
}
else if("Delete".equals(action))
{
if(id==null || id.equals("")){
	out.println("Booking ID Required For Delete");
	return;
}

PreparedStatement ps=con.prepareStatement("delete from booking where booking_id=?");

ps.setInt(1,Integer.parseInt(id));

int row=ps.executeUpdate();

if(row>0)
out.println("Deleted Successfully");
else
out.println("Booking ID not found");

}

else if("Display".equals(action))
{

Statement st=con.createStatement();

ResultSet rs=st.executeQuery("select * from booking");

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

}catch(Exception e){
out.println(e);
}

}
%>

</body>
</html>