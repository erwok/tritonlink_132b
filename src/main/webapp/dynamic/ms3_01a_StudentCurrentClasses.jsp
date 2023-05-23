<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String studentID = request.getParameter("st_id").split(",")[0];
String fullName = request.getParameter("st_id").split(",")[1];
%>
<title>Student <%= studentID %>'s Current Classes</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*" %>

<h2><%= fullName %>'s Current Classes</h2>


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
	
		String GET_current_classes_QUERY = 
	        "SELECT * FROM Taker \n" + 
			"WHERE st_id = '" + studentID + "'";
		ResultSet rs = stmt.executeQuery(GET_current_classes_QUERY);
	%>
	
	<%-- <table>
		<tr>
			<th>Course Number</th>
			<th>Title</th>
			<th>Quarter</th>
			<th>Year</th>
			<th>Section</th>
			<th>Grading Option</th>
			<th>Units Option</th>
		</tr>
		<%
		String getTake = "SELECT * FROM take WHERE st_id = '" + studentID + "';";
		rs = stmt.executeQuery(getTake);
		
		while (rs.next()) {
		%>
		    <tr>
		    	<td><%= rs.getString("cr_courseNumber") %></td>
		    	<td><%= rs.getString("cl_title") %></td>
		    	<td><%= rs.getString("cl_quarter") %></td>
		    	<td><%= rs.getInt("cl_year") %></td>
		    	<td><%= rs.getString("s_sectionID") %></td>
		    	<td><%= rs.getString("take_gradingOption") %></td>
		    	<td><%= rs.getString("take_units") %></td>
		    </tr>
		<%
		}
		%>
	</table> --%>
	
	<table style="border-collapse: collapse;">
	    <tr style="border-bottom: 1px solid black;">
	        <th style="border: 1px solid black; padding: 5px;">Course Number</th>
	        <th style="border: 1px solid black; padding: 5px;">Title</th>
	        <th style="border: 1px solid black; padding: 5px;">Quarter</th>
	        <th style="border: 1px solid black; padding: 5px;">Year</th>
	        <th style="border: 1px solid black; padding: 5px;">Section</th>
	        <th style="border: 1px solid black; padding: 5px;">Grading Option</th>
	        <th style="border: 1px solid black; padding: 5px;">Units Option</th>
	    </tr>
	    <% 
	    String getTake = "SELECT * FROM take WHERE st_id = '" + studentID + "';";
		rs = stmt.executeQuery(getTake);
	    
	    while (rs.next()) { 
	    %>
	        <tr style="border-bottom: 1px solid black;">
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("cr_courseNumber") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("cl_title") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("cl_quarter") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getInt("cl_year") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("s_sectionID") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("take_gradingOption") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("take_units") %></td>
	        </tr>
	    <% } %>
	</table>
	
	
	
	
	<%
	rs.close();
	%>

	<%				
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
	<a href="./ms3_01a_StudentSelectionForCurrentClasses.jsp">Back to student selection page</a>
	<br>
	<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>

<!--
	Display the classes currently taken by student X:

a. The form is an HTML SELECT control with all students enrolled in the current quarter.   
Display the SSN, FIRSTNAME, MIDDLENAME and LASTNAME attributes of STUDENTs given their SSN attribute.

b. The report should display the classes taken by X in the current quarter.

c. On the report page display all attributes of the CLASS entity and the UNITS and 
SECTION attributes of the relationship connecting STUDENTS with the CLASS they take.
	
Given ssn of a student = <ssn>

a. SELECT S.* FROM Student S, Taker T WHERE T.st_ssn = '<ssn>' AND S.st_id = T.st_id;

b. SELECT T.* FROM Take T WHERE st_ssn = '<ssn>';

c. SELECT C.* FROM Course C, Take T where C.cr_coursenumber = T.cr_coursenumber;

-->