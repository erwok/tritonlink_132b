<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String courseNum = request.getParameter("courseNum");
String professor = request.getParameter("professor");
String quarter = request.getParameter("quarter");
int year = Integer.parseInt(request.getParameter("year"));
%>
<title><%= courseNum %> taught by <%= professor %> in <%= quarter + " " + year %> Grade Counts (MS5)</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*, java.util.*" %>

<h2><%= courseNum %> taught by <%= professor %> in <%= quarter + " " + year %> Cumulative Grade Counts (MS5)</h2>

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
		ResultSet rs = null;
	%>
	
	
	<%
		String get_grades_for_course_taught_by_prof_cpqg = 
			"SELECT * FROM CPQG \n" + 
			"WHERE course_number = '" + courseNum + "' \n" + 
			"AND professor = '" + professor + "' \n" +
			"AND quarter = '" + quarter + "' \n" +
			"AND year = '" + year + "'";
		rs = stmt.executeQuery(get_grades_for_course_taught_by_prof_cpqg);
		rs.next();
	%>
	
	<p>(Note: +, - also counted in each column; ex: A+ counts as A)</p>
	<table style="border-collapse: collapse; width: 20%">
    <tr style="border-bottom: 1px solid black;">
        <th style="border: 1px solid black; padding: 5px;">A</th>
        <th style="border: 1px solid black; padding: 5px;">B</th>
        <th style="border: 1px solid black; padding: 5px;">C</th>
        <th style="border: 1px solid black; padding: 5px;">D</th>
        <th style="border: 1px solid black; padding: 5px;">Other</th>
    </tr>
    <tr style="border-bottom: 1px solid black;">
        <td style="border: 1px solid black; padding: 5px;"><%= rs.getInt("grades_A") %></td>
        <td style="border: 1px solid black; padding: 5px;"><%= rs.getInt("grades_B") %></td>
        <td style="border: 1px solid black; padding: 5px;"><%= rs.getInt("grades_C") %></td>
        <td style="border: 1px solid black; padding: 5px;"><%= rs.getInt("grades_D") %></td>
        <td style="border: 1px solid black; padding: 5px;"><%= rs.getInt("grades_other") %></td>
    </tr>
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
	<a href="./ms5_SelectionGradeDistributions.jsp">Back to selection page</a>
	<br>
	<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>