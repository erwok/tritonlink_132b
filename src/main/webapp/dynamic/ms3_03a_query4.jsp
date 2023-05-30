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
<title><%= courseNum %> taught by <%= professor %> GPA</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*, java.util.*" %>

<h3><%= courseNum %> taught by <%= professor %> Cumulative GPA</h3>

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
		Map<String, Double> grade_conversion = new HashMap<>();
		grade_conversion.put("A+", 4.3);
		grade_conversion.put("A", 4.0);
		grade_conversion.put("A-", 3.7);
		grade_conversion.put("B+", 3.4);
		grade_conversion.put("B", 3.1);
		grade_conversion.put("B-", 2.8);
		grade_conversion.put("C+", 2.5);
		grade_conversion.put("C", 2.2);
		grade_conversion.put("C-", 1.9);
		grade_conversion.put("D", 1.6);
	
		String get_grades_and_units_for_course_taught_by_prof = 
			"SELECT p.pasttake_units AS units, p.pasttake_grade AS grade \n" + 
			"FROM pasttake p, teaches t \n" +
			"WHERE p.cr_courseNumber = '" + courseNum + "' \n" +
			"AND t.fc_name = '" + professor + "' \n" +
			"AND p.s_sectionid = t.s_sectionID";
		rs = stmt.executeQuery(get_grades_and_units_for_course_taught_by_prof);
		
		double totalPoints = 0.0;
		int totalUnits = 0;
		while (rs.next()) {
		    String g = rs.getString("grade");
		    int u = Integer.parseInt(rs.getString("units"));
		    // ignore "other grades", only look at valid letter grade
		    if (!grade_conversion.containsKey(g)) {
		        continue;
		    }
		    else {
		        totalPoints += grade_conversion.get(g) * u;
		        totalUnits += u;
		    }
		}
		double cumulativeGPA = 0.0;
		boolean noInstances = false;
		if (totalUnits != 0) {
		    cumulativeGPA = ((double)(int)((totalPoints / totalUnits) * 100)) / 100;
		}
		else {
		    noInstances = true;
		}
	%>

	<table style="border-collapse: collapse; width: 10%">
    <tr style="border-bottom: 1px solid black;">
        <th style="border: 1px solid black; padding: 5px;">Cumulative GPA</th>

    </tr>
    <tr style="border-bottom: 1px solid black;">
        <td style="border: 1px solid black; padding: 5px;"><%= noInstances ? "No record" : cumulativeGPA %></td>
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