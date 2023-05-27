<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Select Undergraduate and BSC Degree</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*" %>
	<h2>Select Undergraduate and BSC Degree for Remaining Degree Requirements</h2>
	<%
	try {
	    // Load driver
	    DriverManager.registerDriver(new org.postgresql.Driver());
	    
	    // Make a connection to the Oracle datasource
	    Connection connection = DriverManager.getConnection
		("jdbc:postgresql:tritonlink?user=postgres&password=helloworld");
	%>
	
	<%
		Statement stmt = connection.createStatement();
	%>
	
	<%
	String GET_undergrads_currently_enrolled_QUERY =
	"SELECT s.st_id AS st_id, s.st_ssn AS st_ssn, s.st_firstname AS st_firstname, s.st_middlename AS st_middlename, s.st_lastname as st_lastname \n" +
	"FROM Student s, Undergraduate u, take t \n" + 
	"WHERE s.st_id = u.st_id AND s.st_id = t.st_id";
	ResultSet rs1 = stmt.executeQuery(GET_undergrads_currently_enrolled_QUERY);
	
	
	String GET_degrees_QUERY = "SELECT * FROM Degree";
	ResultSet rs2 = stmt.executeQuery(GET_degrees_QUERY);
	%>
	
	
	<h4>Select Currently Enrolled Undergrad and Degree</h4>
	<form action="ms3_01d_UndergraduateRemainingDegreeRequirements.jsp" method="get">
	    <input type="hidden" value="select" name="action">
        <select name="st_id">
            <option value="" selected disabled>Select student</option>
            <% while (rs1.next()) {
                String st_ssn = rs1.getString("st_ssn");
                String f = rs1.getString("st_firstname");
                String m = rs1.getString("st_middlename");
                String l = rs1.getString("st_lastname");
                String fullName = f + " " + m + " " + l;
            %>
                <option value="<%= rs1.getString("st_id") + "," + fullName %>"><%= "SSN: " + st_ssn + ", Name: " + fullName %></option>
            <% } %>
        </select>
        <br>
        <br>
        <select name="majorcode">
            <option value="" selected disabled>Select Degree</option>
            <% while (rs2.next()) {
                String majorCode = rs2.getString("majorcode");
                String type = rs2.getString("type");
            %>
                <option value="<%= majorCode %>"><%= majorCode + ", " + type %></option>
            <% } %>
        </select>
	    <input type="submit" value="Select">
	</form>
	

	<%				
	rs1.close();
	rs2.close();
	
	// Close the Statement
	stmt.close();
	
	// Close the connection
	connection.close();
	
	} catch (SQLException sqle) {
	    out.println(sqle.getMessage());
	} catch (Exception e) {
	    out.println(e.getMessage());
	}
	%>
	
	
	<br>
	<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>