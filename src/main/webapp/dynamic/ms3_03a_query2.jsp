<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String courseNum = request.getParameter("courseNum");
String professor = request.getParameter("professor");
%>
<title><%= courseNum %> taught by <%= professor %> Grade Counts</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*, java.util.*" %>

<h2><%= courseNum %> taught by <%= professor %> Cumulative Grade Counts</h2>

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
		String get_grades_for_course_taught_by_prof = 
			"SELECT p.pasttake_grade AS grade FROM pasttake p, teaches t \n" +
			"WHERE p.cr_courseNumber = '" + courseNum + "' \n" +
			"AND t.fc_name = '" + professor + "'";
		rs = stmt.executeQuery(get_grades_for_course_taught_by_prof);
		
		// 0: A, 1: B, 2: C, 3: D, 4: other 
		int[] gradeCounts = new int[5];
		while (rs.next()) {
		    String g = rs.getString("grade");
		    if (g.equals("A+") || g.equals("A") || g.equals("A-")) {
		        gradeCounts[0] += 1;
		    }
		    else if (g.equals("B+") || g.equals("B") || g.equals("B-")) {
		        gradeCounts[1] += 1;
		    }
		    else if (g.equals("C+") || g.equals("C") || g.equals("C-")) {
		        gradeCounts[2] += 1;
		    }
		    else if (g.equals("D")) {
		        gradeCounts[3] += 1;
		    }
		    else {
		        gradeCounts[4] += 1;
		    }
		}
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
        <td style="border: 1px solid black; padding: 5px;"><%= gradeCounts[0] %></td>
        <td style="border: 1px solid black; padding: 5px;"><%= gradeCounts[1] %></td>
        <td style="border: 1px solid black; padding: 5px;"><%= gradeCounts[2] %></td>
        <td style="border: 1px solid black; padding: 5px;"><%= gradeCounts[3] %></td>
        <td style="border: 1px solid black; padding: 5px;"><%= gradeCounts[4] %></td>
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
	<a href="./ms3_03a_SelectionForGradeDistributions.jsp">Back to selection page</a>
	<br>
	<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>