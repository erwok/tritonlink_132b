<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quarter Dates Entry Form</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*" %>
	<h2>Quarter Dates Entry Form</h2>

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
	
	<!-- Insertion stuff? -->
	<%
		// Check if an insertion is required
		String action = request.getParameter("action");
		if (action != null && action.equals("insert")) {
		    
		    connection.setAutoCommit(false);
		    
		    PreparedStatement pstmt = connection.prepareStatement(
		    ("INSERT INTO QuarterDates VALUES (?, ?, ?, ?)"));
		    
		    pstmt.setString(1, request.getParameter("quarter"));
		    pstmt.setInt(2, Integer.parseInt(request.getParameter("year")));
		    pstmt.setString(3, request.getParameter("start_date"));
		    pstmt.setString(4, request.getParameter("end_date"));
		    
		    pstmt.executeUpdate();
		    
		    connection.commit();
		    connection.setAutoCommit(true);
		}
	%>
	
	<!-- Update stuff? -->
	<%
	// Check if an update is requested
	if (action != null && action.equals("update")) {
	    
	    connection.setAutoCommit(false);
	    
	    PreparedStatement pstmt1 = connection.prepareStatement(
	        "UPDATE QuarterDates SET start_date = ?, end_date = ? WHERE quarter = ? AND year = ?");
	    pstmt1.setString(1, request.getParameter("start_date"));
	    pstmt1.setString(2, request.getParameter("end_date"));
	    pstmt1.setString(3, request.getParameter("quarter"));
	    pstmt1.setInt(4, Integer.parseInt(request.getParameter("year")));
	    
	    pstmt1.executeUpdate();
    
	    connection.setAutoCommit(false);
	    connection.setAutoCommit(true);
	}
	%>
	
	<!-- Delete stuff? -->
	<%
	// Check if a delete is requested
	if (action != null && action.equals("delete")) {
	    
	    connection.setAutoCommit(false);

	    PreparedStatement pstmt = connection.prepareStatement(
	    	"DELETE FROM QuarterDates \n"+
			"WHERE quarter = ? AND year = ?"
		);
	    
	    pstmt.setString(1, request.getParameter("quarter"));
	    pstmt.setInt(2, Integer.parseInt(request.getParameter("year")));
	    pstmt.executeUpdate();
	    
	    connection.setAutoCommit(false);
	    connection.setAutoCommit(true);
	}
	%>
	
	
	<table>
		<tr>
			<th>Quarter</th>
			<th>Year</th>
			<th>Start Date</th>
			<th>End Date</th>
		</tr>
		<tr>
		    <form action="19_QuarterDatesEntry.jsp" method="get">
		        <input type="hidden" value="insert" name="action">
		        <td><input value="" name="quarter" size="10"></td>
		        <td><input value="" name="year" size="10"></td>
		        <td><input value="" name="start_date" size="10"></td>
		        <td><input value="" name="end_date" size="10"></td>
		        <td><input type="submit" value="Insert"></td>
		    </form>
		</tr>


	<!-- Iteration stuff? -->
	<%
	ResultSet rs = stmt.executeQuery(
        "SELECT * FROM QuarterDates \n" +
        "ORDER BY year, \n" +
        "         CASE quarter \n" +
		"         WHEN 'WINTER' THEN 1 \n" +
	    "         WHEN 'SPRING' THEN 2 \n" +
	    "         WHEN 'FALL' THEN 3 \n" +
	    "         ELSE 4 \n" +
	    "         END"
    );
	
	while (rs.next()) {
	%>
		<tr>
			<form action="19_QuarterDatesEntry.jsp" method="get">
				<input type="hidden" value="update" name="action">
				<td><input value="<%= rs.getString("quarter") %>" name="quarter" size="10"></td>
		        <td><input value="<%= rs.getInt("year") %>" name="year" size="10"></td>
		        <td><input value="<%= rs.getString("start_date") %>" name="start_date" size="10"></td>
		        <td><input value="<%= rs.getString("end_date") %>" name="end_date" size="10"></td>
				<td><input type="submit" value="Update"></td>
			</form>
			<form action="19_QuarterDatesEntry.jsp" method="get">
				<input type="hidden" value="delete" name="action">
				<input type="hidden" value="<%= rs.getString("quarter") %>" name="quarter">
				<input type="hidden" value="<%= rs.getInt("year") %>" name="year">
				<td><input type="submit" value="Delete"></td>
			</form>
		</tr>
	
	<% 
	} 
	%>
	
	</table>
	
	<%
	// Close the ResultSet
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
	<br>
	<a href="./00_index.jsp">Back to Home Page</a>
	
	<%
	/* 
	
	CREATE TABLE QuarterDates (
    	quarter VARCHAR(255) NOT NULL,
    	year INT NOT NULL,
    	start_date VARCHAR(255) NOT NULL,
    	end_date VARCHAR(255) NOT NULL,
    	CONSTRAINT Pk_qd PRIMARY KEY (quarter, year)
    );
	
	
	*/
	%>

</body>
</html>