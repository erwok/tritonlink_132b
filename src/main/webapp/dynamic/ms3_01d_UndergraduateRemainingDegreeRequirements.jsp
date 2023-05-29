<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String studentID = request.getParameter("st_id").split(",")[0];
String fullName = request.getParameter("st_id").split(",")[1];
String majorCode = request.getParameter("majorcode");
%>
<title><%= fullName %>'s Remaining Requirements for <%= majorCode %></title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*" %>

<h2><%= fullName %>'s Remaining Requirements for <%= majorCode %></h2>


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
		
		String GET_total_units_taken_by_undergraduate_QUERY = 
	        "SELECT SUM(CAST(p.pasttake_units AS INTEGER)) AS totalUnitsTaken \n" +
	        "FROM Undergraduate u, pasttake p \n" +
	        "WHERE u.st_id = p.st_id";
		ResultSet rs = stmt.executeQuery(GET_total_units_taken_by_undergraduate_QUERY);
		
		rs.next();
		int totalUnitsTaken = rs.getInt("totalUnitsTaken");
		
		String GET_required_number_of_units_for_degree_QUERY =
	        "SELECT * FROM Degree WHERE majorcode = '" + majorCode + "'";
		rs = stmt.executeQuery(GET_required_number_of_units_for_degree_QUERY);
		
		rs.next();
		int requiredTotalUnits = rs.getInt("total");
		int requiredLowerUnits = rs.getInt("lower");
		int requiredUpperUnits = rs.getInt("upper");
		int requiredElectiveUnits = rs.getInt("elective");
		int requiredTechnicalUnits = rs.getInt("technical");
		
		int remainingTotalUnits = requiredTotalUnits - totalUnitsTaken;
		if (remainingTotalUnits < 0) {
		    remainingTotalUnits = 0;
		}
		
		
	%>
	
	<h4>Remaining Units Per Requirement</h4>
	<table style="border-collapse: collapse;">
	    <tr style="border-bottom: 1px solid black;">
	        <th style="border: 1px solid black; padding: 5px;">Total</th>
	        <th style="border: 1px solid black; padding: 5px;">Lower</th>
	        <th style="border: 1px solid black; padding: 5px;">Upper</th>
	        <th style="border: 1px solid black; padding: 5px;">Elective</th>
	        <th style="border: 1px solid black; padding: 5px;">Technical</th>
	    </tr>
	    <%
	    String GET_lower_div_courses_units_total_QUERY = 
		    "SELECT SUM(CAST(p.pasttake_units AS INTEGER)) AS lowerDivUnitsTaken \n" +
		    "FROM Undergraduate u, pasttake p \n" + 
		    "WHERE u.st_id = p.st_id \n" +
            "AND u.st_id = '" + studentID + "' \n" +
            "AND ((p.cr_courseNumber SIMILAR TO '%[A-z][1-9][0-9]') \n" +
			"OR (p.cr_courseNumber SIMILAR TO '%[A-z][1-9][0-9][a-z]') \n" +
		    "OR (p.cr_courseNumber SIMILAR TO '%[A-z][1-9]') \n" +
		    "OR (p.cr_courseNumber SIMILAR TO '%[A-z][1-9][a-z]'))";
		rs = stmt.executeQuery(GET_lower_div_courses_units_total_QUERY);
		
		rs.next();
		
	    int remainingLowerDivUnits = requiredLowerUnits - rs.getInt("lowerDivUnitsTaken");
	    if (remainingLowerDivUnits < 0) {
	        remainingLowerDivUnits = 0;
	    }
	    
	    String GET_upper_div_courses_units_total_QUERY = 
	    	"SELECT SUM(CAST(p.pasttake_units AS INTEGER)) AS upperDivUnitsTaken \n" +
	    	"FROM Undergraduate u, pasttake p \n" +
	    	"WHERE u.st_id = p.st_id \n" +
	    	"AND u.st_id = '" + studentID + "' \n" +
   	        "AND p.cr_courseNumber SIMILAR TO '%[1-9][0-9][0-9]%'";
	    rs = stmt.executeQuery(GET_upper_div_courses_units_total_QUERY);
	    
	    rs.next();
	    
	    int remainingUpperDivUnits = requiredUpperUnits - rs.getInt("upperDivUnitsTaken");
	    if (remainingUpperDivUnits < 0) {
	        remainingUpperDivUnits = 0;
	    }
	    
	    int remainingElectiveUnits = requiredElectiveUnits - rs.getInt("upperDivUnitsTaken");
	    if (remainingElectiveUnits < 0) {
	        remainingElectiveUnits = 0;
	    }
	    
	    int remainingTechnicalUnits = requiredTechnicalUnits - rs.getInt("upperDivUnitsTaken");
	    if (remainingTechnicalUnits < 0) {
	        remainingTechnicalUnits = 0;
	    }
	    %>
	    
        <tr style="border-bottom: 1px solid black;">
            <td style="border: 1px solid black; padding: 5px;"><%= remainingTotalUnits %></td>
            <td style="border: 1px solid black; padding: 5px;"><%= remainingLowerDivUnits %></td>
            <td style="border: 1px solid black; padding: 5px;"><%= remainingUpperDivUnits %></td>
            <td style="border: 1px solid black; padding: 5px;"><%= remainingElectiveUnits %></td>
            <td style="border: 1px solid black; padding: 5px;"><%= remainingTechnicalUnits %></td>
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
	
	<%
	/* 
	
	
	
	
	
	
	*/
	
	
	%>
	
	
	<br>
	<a href="./ms3_01d_SelectUgAndBSCDegree.jsp">Back to selection page</a>
	<br>
	<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>