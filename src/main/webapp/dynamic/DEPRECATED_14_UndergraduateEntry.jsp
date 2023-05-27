<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Undergraduate Entry Page</title>
</head>
<body>
			<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<b>Undergraduate Entry Page</b>
			
			<table>
				<tr>
					<th>ID</th>
					<th>SSN</th>
					<th>EnrollmentStatus</th>
					<th>Residential</th>
					<th>First Name</th>
					<th>Middle Name</th>
					<th>Last Name</th>
					<th>Major</th>
					<th>Minor</th>
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
					    ("INSERT INTO Undergraduate VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"));

					    pstmt.setString(1, request.getParameter("st_ID"));
					    pstmt.setString(2, request.getParameter("st_SSN"));
					    pstmt.setString(3, request.getParameter("st_enrollmentStatus"));
					    pstmt.setString(4, request.getParameter("st_residential"));
					    pstmt.setString(5, request.getParameter("st_firstName"));
					    pstmt.setString(6, request.getParameter("st_middleName"));
					    pstmt.setString(7, request.getParameter("st_lastName"));
					    pstmt.setString(8, request.getParameter("major"));
					    pstmt.setString(9, request.getParameter("minor"));
					    
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
				    	"UPDATE Undergraduate SET st_SSN = ?, st_enrollmentStatus = ?, st_residential = ?,\n"+
		    	        "st_firstName = ?, st_middleName = ?, st_lastName = ?, \n"+
				    	"major = ?, minor = ? \n"+
				    	"WHERE st_ID = ? "
				    );
				    
				    pstatement.setString(1, request.getParameter("st_SSN"));
				    pstatement.setString(2, request.getParameter("st_enrollmentStatus"));
				    pstatement.setString(3, request.getParameter("st_residential"));
				    pstatement.setString(4, request.getParameter("st_firstName"));
				    pstatement.setString(5, request.getParameter("st_middleName"));
				    pstatement.setString(6, request.getParameter("st_lastName"));
				    pstatement.setString(7, request.getParameter("major"));
				    pstatement.setString(8, request.getParameter("minor"));
				    pstatement.setString(9, request.getParameter("st_ID"));
				    
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
				    
				    PreparedStatement pstmt = connection.prepareStatement(
				    	"DELETE FROM Undergraduate \n"+
				    	"WHERE st_ID = ? "
				    );
				    
				    pstmt.setString(1, request.getParameter("st_ID"));
				    int rowCount = pstmt.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
					
				<%
					Statement stmt = connection.createStatement();
				
					String GET_Undergraduate_QUERY = "SELECT * FROM Undergraduate";
					ResultSet rs = stmt.executeQuery(GET_Undergraduate_QUERY);
				%>
				
				<tr>
					<form action="14_UndergraduateEntry.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="st_ID" size="10"></th>
						<th><input value="" name="st_SSN" size="10"></th>
						<th><input value="" name="st_enrollmentStatus" size="10"></th>
						<th><input value="" name="st_residential" size="10"></th>
						<th><input value="" name="st_firstName" size="10"></th>
						<th><input value="" name="st_middleName" size="10"></th>
						<th><input value="" name="st_lastName" size="10"></th>
						<th><input value="" name="major" size="10"></th>
						<th><input value="" name="minor" size="10"></th>
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
					"SELECT * FROM Undergraduate \n"+
					"ORDER BY st_ID, st_SSN, st_enrollmentStatus, st_residential, st_firstName, st_middleName, st_lastName, major, minor"
				);
				
				while (rs.next()) {
				%>
				<tr>
					<form action="14_UndergraduateEntry.jsp" method="get">
						<input type="hidden" value="update" name="action">
						<td><input value="<%= rs.getString("st_ID") %>" name="st_ID"></td>
						<td><input value="<%= rs.getString("st_SSN") %>" name="st_SSN"></td>
						<td><input value="<%= rs.getString("st_enrollmentStatus") %>" name="st_enrollmentStatus"></td>
						<td><input value="<%= rs.getString("st_residential") %>" name="st_residential"></td>
						<td><input value="<%= rs.getString("st_firstName") %>" name="st_firstName"></td>
						<td><input value="<%= rs.getString("st_middleName") %>" name="st_middleName"></td>
						<td><input value="<%= rs.getString("st_lastName") %>" name="st_lastName"></td>
						<td><input value="<%= rs.getString("major") %>" name="major"></td>
						<td><input value="<%= rs.getString("minor") %>" name="minor"></td>
						<td><input type="submit" value="Update"></td>
					</form>
					<form action="14_UndergraduateEntry.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= rs.getString("st_ID") %>" name="st_ID">
						<input type="hidden" value="<%= rs.getString("st_SSN") %>" name="st_SSN">
						<input type="hidden" value="<%= rs.getString("st_enrollmentStatus") %>" name="st_enrollmentStatus">
						<input type="hidden" value="<%= rs.getString("st_residential") %>" name="st_residential">
						<input type="hidden" value="<%= rs.getString("st_firstName") %>" name="st_firstName">
						<input type="hidden" value="<%= rs.getString("st_middleName") %>" name="st_middleName">
						<input type="hidden" value="<%= rs.getString("st_lastName") %>" name="st_lastName">
						<input type="hidden" value="<%= rs.getString("major") %>" name="major">
						<input type="hidden" value="<%= rs.getString("minor") %>" name="minor">
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
			CREATE TABLE Student (
				st_ID VARCHAR(255) PRIMARY KEY, 
				st_SSN VARCHAR(255) UNIQUE NOT NULL,
			    st_enrollmentStatus VARCHAR(255) NOT NULL, 
				st_residential VARCHAR(255) NOT NULL,
			    st_firstName VARCHAR(255) NOT NULL, 
				st_middleName VARCHAR(255), 
				st_lastName VARCHAR(255) NOT NULL
			);
			
			CREATE TABLE Undergraduate (
		        st_ID VARCHAR(255) PRIMARY KEY, 
				st_SSN VARCHAR(255) UNIQUE NOT NULL,
			    st_enrollmentStatus VARCHAR(255) NOT NULL, 
				st_residential VARCHAR(255) NOT NULL,
			    st_firstName VARCHAR(255) NOT NULL, 
				st_middleName VARCHAR(255), 
				st_lastName VARCHAR(255) NOT NULL,
				major VARCHAR(255) NOT NULL,
				minor VARCHAR(255) NOT NULL
	        );
			*/
			%>
			
			
			<a href="./00_index.jsp">Back to Home Page</a>
			

</body>
</html>