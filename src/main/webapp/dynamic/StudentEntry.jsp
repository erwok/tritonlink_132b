<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Student home page</title>
</head>
<body>
			<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<b>Student Home Page</b>
			
			<table>
				<tr>
					<th>ID</th>
					<th>SSN</th>
					<th>EnrollmentStatus</th>
					<th>Residential</th>
					<th>First Name</th>
					<th>Middle Name</th>
					<th>Last Name</th>
				</tr>
				<%
				try {
				    // Load driver
				    DriverManager.registerDriver(new org.postgresql.Driver());
				    
				    // Make a connection to the Oracle datasource
				    Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlink?user=postgres&password=helloworld");
				%>
				
				<!-- Insertion stuff? -->
				<%
					// Check if an insertion is required
					String action = request.getParameter("action");
					if (action != null && action.equals("insert")) {
					    
					    connection.setAutoCommit(false);
					    
					    // Create the prepared statement and use it to
					    // INSERT the Student attrs INTO the Student table
					    PreparedStatement pstmt = connection.prepareStatement(
					    ("INSERT INTO Student VALUES (?, ?, ?, ?, ?, ?, ?)"));

					    pstmt.setString(1, request.getParameter("st_ID"));
					    pstmt.setString(2, request.getParameter("st_SSN"));
					    pstmt.setString(3, request.getParameter("st_enrollmentStatus"));
					    pstmt.setString(4, request.getParameter("st_residential"));
					    pstmt.setString(5, request.getParameter("st_firstName"));
					    pstmt.setString(6, request.getParameter("st_middleName"));
					    pstmt.setString(7, request.getParameter("st_lastName"));
					    
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
				    
				    // Create the prepared statement and use it to
				    // UPDATE the Student attributes in the Student table.
				    PreparedStatement pstatement = connection.prepareStatement(
				    	"UPDATE Student SET st_ID = ?, st_SSN = ?, st_enrollmentStatus = ?, st_residential = ?, st_firstName = ?, st_middleName = ?, st_lastName = ? \n"+
				    	"WHERE st_ID = ? "
				    );
				    
				    pstatement.setString(1, request.getParameter("st_ID"));
				    pstatement.setString(2, request.getParameter("st_SSN"));
				    pstatement.setString(3, request.getParameter("st_enrollmentStatus"));
				    pstatement.setString(4, request.getParameter("st_residential"));
				    pstatement.setString(5, request.getParameter("st_firstName"));
				    pstatement.setString(6, request.getParameter("st_middleName"));
				    pstatement.setString(7, request.getParameter("st_lastName"));
				    pstatement.setString(8, request.getParameter("st_ID"));
				    int rowCount = pstatement.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
				<!-- Delete stuff? -->
				<%
				// Check if a delete is requested
				if (action != null && action.equals("delete")) {
				    
				    connection.setAutoCommit(false);
				    
				    // Create the prepared statement and use it to
				    // DELETE the Student FROM the Student table.
				    PreparedStatement pstmt = connection.prepareStatement(
				    	"DELETE FROM Student \n"+
				    	"WHERE st_ID = ? AND st_SSN = ? AND st_enrollmentStatus = ? AND st_residential = ? AND st_firstName = ? AND st_middleName = ? AND st_lastName = ?"
				    );
				    
				    pstmt.setString(1, request.getParameter("st_ID"));
				    pstmt.setString(2, request.getParameter("st_SSN"));
				    pstmt.setString(3, request.getParameter("st_enrollmentStatus"));
				    pstmt.setString(4, request.getParameter("st_residential"));
				    pstmt.setString(5, request.getParameter("st_firstName"));
				    pstmt.setString(6, request.getParameter("st_middleName"));
				    pstmt.setString(7, request.getParameter("st_lastName"));
				    int rowCount = pstmt.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
					
				<%
					Statement stmt = connection.createStatement();
				
					String GET_Student_QUERY = "SELECT * FROM Student";
					ResultSet rs = stmt.executeQuery(GET_Student_QUERY);
				%>
				
				<tr>
					<form action="StudentEntry.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="st_ID" size="10"></th>
						<th><input value="" name="st_SSN" size="10"></th>
						<th><input value="" name="st_enrollmentStatus" size="10"></th>
						<th><input value="" name="st_residential" size="10"></th>
						<th><input value="" name="st_firstName" size="10"></th>
						<th><input value="" name="st_middleName" size="10"></th>
						<th><input value="" name="st_lastName" size="10"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
					
				<%
					while (rs.next()) {    

					}
				%>
				
				<%
				// Close the ResultSet
				rs.close();
				
				%>
				
				
				<!-- Iteration stuff? -->
				<%
				rs = stmt.executeQuery(
					"SELECT * FROM Student \n"+
					"ORDER BY st_ID, st_SSN, st_enrollmentStatus, st_residential, st_firstName, st_middleName, st_lastName"
				);
				
				while (rs.next()) {
				%>
				<tr>
					<form action="StudentEntry.jsp" method="get">
						<input type="hidden" value="update" name="action">
						<td><input value="<%= rs.getString("st_ID") %>" name="st_ID"></td>
						<td><input value="<%= rs.getString("st_SSN") %>" name="st_SSN"></td>
						<td><input value="<%= rs.getString("st_enrollmentStatus") %>" name="st_enrollmentStatus"></td>
						<td><input value="<%= rs.getString("st_residential") %>" name="st_residential"></td>
						<td><input value="<%= rs.getString("st_firstName") %>" name="st_firstName"></td>
						<td><input value="<%= rs.getString("st_middleName") %>" name="st_middleName"></td>
						<td><input value="<%= rs.getString("st_lastName") %>" name="st_lastName"></td>
						<td><input type="submit" value="Update"></td>
					</form>
					<form action="StudentEntry.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= rs.getString("st_ID") %>" name="st_ID">
						<input type="hidden" value="<%= rs.getString("st_SSN") %>" name="st_SSN">
						<input type="hidden" value="<%= rs.getString("st_enrollmentStatus") %>" name="st_enrollmentStatus">
						<input type="hidden" value="<%= rs.getString("st_residential") %>" name="st_residential">
						<input type="hidden" value="<%= rs.getString("st_firstName") %>" name="st_firstName">
						<input type="hidden" value="<%= rs.getString("st_middleName") %>" name="st_middleName">
						<input type="hidden" value="<%= rs.getString("st_lastName") %>" name="st_lastName">
						<td><input type="submit" value="Delete"></td>
					</form>
				</tr>
				<%
				}
				
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
			</table>
			
			
			<%
			/* experiment queries */
			
			/* 
			
			CREATE TABLE Student ( st_ID VARCHAR(255) PRIMARY KEY, st_SSN VARCHAR(255) UNIQUE NOT NULL, st_enrollmentStatus VARCHAR(255) NOT NULL, st_residential VARCHAR(255) NOT NULL, st_firstName VARCHAR(255) NOT NULL, st_middleName VARCHAR(255) , st_lastName VARCHAR(255) NOT NULL);

			*/
			%>
			
			
			<a href="./index.jsp">Back to Home Page</a>
			

</body>
</html>

