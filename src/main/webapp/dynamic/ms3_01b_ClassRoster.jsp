<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String[] everything = request.getParameter("section_stuff").split(",");
String courseNumber = everything[0];
String classTitle = everything[1];
String classQuarter = everything[3];
String classYear = everything[2];
String s_sectionID = everything[4];
%>
<title><%= courseNumber + " " + classTitle + " " + classQuarter + " " + classYear + " Section " + s_sectionID %></title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*" %>

<h2><%= courseNumber + " " + classTitle + " " + classQuarter + " " + classYear + " Section " + s_sectionID %>'s Roster</h2>


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
		
		ResultSet rs;
		String GET_section_roster_QUERY;
		
		// the class is currently offered so only look in take
		if (classQuarter.equals("SPRING") && classYear.equals("2018")) {
		    GET_section_roster_QUERY = 
	        	"SELECT s.st_id, s.st_ssn, s.st_enrollmentstatus, s.st_residential, s.st_firstName, s.st_middleName, s.st_lastName, \n" +
		    	"t.take_units AS units, t.take_gradingoption AS gradingoption \n" +
	        	"FROM Student s, take t \n" + 
		    	"WHERE s.st_id = t.st_id AND \n" +
	        	"t.cr_courseNumber = '" + courseNumber + "' AND \n" +
		    	"t.cl_title = '" + classTitle + "' AND \n" +
	        	"t.cl_year = '" + classYear + "' AND \n" + 
		    	"t.cl_quarter = '" + classQuarter + "' AND \n" +
	        	"t.s_sectionID = '" + s_sectionID + "'";
		    rs = stmt.executeQuery(GET_section_roster_QUERY);
		}
		// the class was offered in the past so only look in pasttake
		else {
		    GET_section_roster_QUERY = 
	        	"SELECT s.st_id, s.st_ssn, s.st_enrollmentstatus, s.st_residential, s.st_firstName, s.st_middleName, s.st_lastName, \n" +
		    	"p.pasttake_units AS units, p.pasttake_gradingoption AS gradingoption \n" +
	        	"FROM Student s, pasttake p \n" + 
		    	"WHERE s.st_id = p.st_id AND \n" + 
			    "p.cr_courseNumber = '" + courseNumber + "' AND \n" +
		    	"p.cl_title = '" + classTitle + "' AND \n" +
	        	"p.cl_year = '" + classYear + "' AND \n" + 
		    	"p.cl_quarter = '" + classQuarter + "' AND \n" +
	        	"p.s_sectionID = '" + s_sectionID + "'";
		    rs = stmt.executeQuery(GET_section_roster_QUERY);
		}
	%>
	
	<table style="border-collapse: collapse;">
	    <tr style="border-bottom: 1px solid black;">
	        <th style="border: 1px solid black; padding: 5px;">Student ID</th>
	        <th style="border: 1px solid black; padding: 5px;">SSN</th>
	        <th style="border: 1px solid black; padding: 5px;">Enrollment Status</th>
	        <th style="border: 1px solid black; padding: 5px;">Residential Status</th>
	        <th style="border: 1px solid black; padding: 5px;">First Name</th>
	        <th style="border: 1px solid black; padding: 5px;">Middle Name</th>
	        <th style="border: 1px solid black; padding: 5px;">Last Name</th>
	        <th style="border: 1px solid black; padding: 5px;">Units</th>
	        <th style="border: 1px solid black; padding: 5px;">Grading Option</th>
	    </tr>
	    <% 
	    while (rs.next()) { 
	    %>
	        <tr style="border-bottom: 1px solid black;">
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("st_id") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("st_ssn") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("st_enrollmentstatus") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("st_residential") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("st_firstname") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("st_middlename") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("st_lastname") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("units") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("gradingoption") %></td>
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
	<a href="./ms3_01b_ClassSelectionForRoster.jsp">Back to class section selection page</a>
	<br>
	<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>