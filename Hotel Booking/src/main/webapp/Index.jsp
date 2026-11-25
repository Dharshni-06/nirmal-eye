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
<form action="BookingServlet" method="post">
Booking Id : <input type="text" name="id"/><br><br>
Customer Name : <input type="text" name="name" /><br><br>
Phone Number : <input type="text" name="phone"/><br><br>
Email ID : <input type="text" name="mail"/>
Room Type : <select name="room">
            <option value="">Select</option>
            <option value="Deluxe">Deluxe</option>
            <option value="Suite">Suite</option>
            <option value="Standard">Standard</option>
            </select><br><br>
Number Of Days : <input type="text" name="days"><br><br>
<input type="submit" name="action" value="Insert"/> 
<input type="submit" name="action" value="Update"/> 
<input type="submit" name="action" value="Delete"/> 
<input type="submit" name="action" value="Display"/> 
</form>
</body>
</html>