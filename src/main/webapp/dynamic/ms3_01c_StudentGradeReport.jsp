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
<title><%= fullName %>'s Grade Report</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*" %>
<%@ page import="java.util.Map, java.util.HashMap" %>

<h2><%= fullName %>'s Grade Report</h2>


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
	
		String GET_student_taken_classes_QUERY = 
	        "SELECT * FROM (\n" +
	        "    SELECT p.cr_coursenumber, p.cl_title, p.cl_quarter, p.cl_year, p.s_sectionID, \n" + 
	        "    p.pasttake_gradingoption AS gradingoption, p.pasttake_units AS units, p.pasttake_grade AS grade, \n" +
	        "    s.s_capacity \n" +
	        "    FROM pasttake p, section s \n" + 
	        "    WHERE p.st_id = '" + studentID + "' \n" +
	        "    AND s.coursenumber = p.cr_coursenumber AND s.classtitle = p.cl_title AND s.classquarter = p.cl_quarter \n" +
	        "    AND s.classyear = p.cl_year AND s.s_sectionID = p.s_sectionID \n" +
	        "    UNION \n" +
	        "    SELECT t.cr_coursenumber, t.cl_title, t.cl_quarter, t.cl_year, t.s_sectionID, \n" + 
	        "    t.take_gradingoption AS gradingoption, t.take_units AS units, 'IN' AS grade, \n" +
	        "    s.s_capacity \n" +
	        "    FROM take t, section s \n" +
	        "    WHERE t.st_id = '" + studentID + "' \n" +
	        "    AND s.coursenumber = t.cr_coursenumber AND s.classtitle = t.cl_title AND s.classquarter = t.cl_quarter \n" +
	        "    AND s.classyear = t.cl_year AND s.s_sectionID = t.s_sectionID \n" +
	        ") AS subquery \n" +
	        "ORDER BY cl_year, \n" +
	        "         CASE cl_quarter \n" +
	        "         WHEN 'WINTER' THEN 1 \n" +
	        "         WHEN 'SPRING' THEN 2 \n" +
	        "         WHEN 'FALL' THEN 3 \n" +
	        "         ELSE 4 \n" +
	        "         END";

		ResultSet rs = stmt.executeQuery(GET_student_taken_classes_QUERY);
	%>
	
	<table style="border-collapse: collapse;">
	    <tr style="border-bottom: 1px solid black;">
	        <th style="border: 1px solid black; padding: 5px;">Course Number</th>
	        <th style="border: 1px solid black; padding: 5px;">Title</th>
	        <th style="border: 1px solid black; padding: 5px;">Quarter</th>
	        <th style="border: 1px solid black; padding: 5px;">Year</th>
	        <th style="border: 1px solid black; padding: 5px;">Section</th>
	        <th style="border: 1px solid black; padding: 5px;">Capacity</th>
	        <th style="border: 1px solid black; padding: 5px;">Grading Option</th>
	        <th style="border: 1px solid black; padding: 5px;">Units Option</th>
	        <th style="border: 1px solid black; padding: 5px;">Grade Received</th>
	    </tr>
	    <%
	    while (rs.next()) { 
	    %>
	        <tr style="border-bottom: 1px solid black;">
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("cr_courseNumber") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("cl_title") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("cl_quarter") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getInt("cl_year") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("s_sectionID") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("s_capacity") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("gradingOption") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("units") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("grade") %></td>
	        </tr>
	    <% } %>
	</table>
	
	<%
	String GET_GPA_QUERY = 
	    "SELECT subquery.cl_year, subquery.cl_quarter, subquery.grade, \n" +
	    "       CASE \n" +
	    "           WHEN subquery.grade = 'IN' THEN NULL \n" +
	    "           ELSE g.number_grade \n" +
	    "       END AS number_grade, \n" +
	    "       subquery.units \n" +
	    "FROM (\n" +
	    "    SELECT p.cl_year, p.cl_quarter, p.pasttake_grade AS grade, p.pasttake_units AS units \n" +
	    "    FROM pasttake p \n" +
	    "    WHERE p.st_id = '" + studentID + "' \n" +
	    "    UNION \n" +
	    "    SELECT t.cl_year, t.cl_quarter, 'IN' AS grade, t.take_units AS units \n" +
	    "    FROM take t \n" +
	    "    WHERE t.st_id = '" + studentID + "' \n" +
	    ") AS subquery \n" +
	    "LEFT JOIN grade_conversion g ON subquery.grade = g.letter_grade";
	
	rs = stmt.executeQuery(GET_GPA_QUERY);
	
	Map<String, Double> quarterGPA = new HashMap<>();  // Map to store quarter GPA
	double cumulativeGPA = 0.0;
	double totalCredits = 0.0;
	boolean currentlyEnrolled = false;
	
	while (rs.next()) {
	    String year = rs.getString("cl_year");
	    String quarter = rs.getString("cl_quarter");
	    String grade = rs.getString("grade"); // Retrieve the "grade" column from the ResultSet
	    Double numberGrade = rs.getDouble("number_grade");
	    Double credits = rs.getDouble("units");
	    
	    if (year.equals("2018") && quarter.equals("SPRING")) {
	        currentlyEnrolled = true;
        }
	
	    if (!rs.wasNull() && !grade.equals("IN")) {
	        // Calculate quarter GPA
	        double quarterGradePoints = numberGrade * credits;
	        totalCredits += credits;
	
	        if (year.equals("2018") && quarter.equals("SPRING")) {
	            quarterGPA.put(year + "_" + quarter, null);
	            continue;
	        }
	
	        double currentQuarterGPA = quarterGradePoints / totalCredits;
	
	        // Update cumulative GPA
	        cumulativeGPA = (cumulativeGPA * (totalCredits - credits) + currentQuarterGPA * credits) / totalCredits;
	
	        // Store quarter GPA
	        String quarterKey = year + "_" + quarter;
	        quarterGPA.put(quarterKey, currentQuarterGPA);
	    }
	}
	%>
	
	<br>
	<table style="border-collapse: collapse;">
	    <tr>
	        <th style="border: 1px solid black;">Quarter</th>
	        <th style="border: 1px solid black;">Year</th>
	        <th style="border: 1px solid black;">GPA</th>
	    </tr>
	<%
	for (Map.Entry<String, Double> entry : quarterGPA.entrySet()) {
	    String quarter = entry.getKey().split("_")[1];
	    String year = entry.getKey().split("_")[0];
	    Double quarterGpa = entry.getValue();
	%>
	    <tr>
	        <td style="border: 1px solid black;"><%= quarter %></td>
	        <td style="border: 1px solid black;"><%= year %></td>
	        <td style="border: 1px solid black;">
	        <% if (quarterGpa == null) { %>
	            N/A
	        <% } else { %>
	            <%= quarterGpa %>
	        <% } %>
	        </td>
	    </tr>
	<%
	}
	%>
	<%
	if (currentlyEnrolled) {
	%>
		<tr>
			<td style="border: 1px solid black;">SPRING</td>
	        <td style="border: 1px solid black;">2018</td>
	        <td style="border: 1px solid black;">N/A</td>
		</tr>
	<%
	}
	%>
	</table>
	<br>
	<table style="border-collapse: collapse;">
	    <tr>
	        <th style="border: 1px solid black;">Cumulative GPA</th>
	    </tr>
	    <tr>
	        <td style="border: 1px solid black;"><%= cumulativeGPA %></td>
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
	<a href="./ms3_01c_StudentSelectionForGradeReport.jsp">Back to student selection page</a>
	<br>
	<a href="./00_index.jsp">Back to Home Page</a>
	
	<%
	/* 
	
	create table GRADE_CONVERSION(
        LETTER_GRADE CHAR(2) NOT NULL,
        NUMBER_GRADE DECIMAL(2,1)
    );
	
	insert into grade_conversion values('A+', 4.3);
    insert into grade_conversion values('A', 4);
    insert into grade_conversion values('A-', 3.7);
    insert into grade_conversion values('B+', 3.4);
    insert into grade_conversion values('B', 3.1);
    insert into grade_conversion values('B-', 2.8);
    insert into grade_conversion values('C+', 2.5);
    insert into grade_conversion values('C', 2.2);
    insert into grade_conversion values('C-', 1.9);
    insert into grade_conversion values('D', 1.6);
	
	
	*/
	
	%>

</body>
</html>