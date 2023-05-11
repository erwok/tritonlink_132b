<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Course home page</title>
</head>
<body>
			<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<b>Course Home Page</b>
			
			<table>
				<tr>
					<th>Course Number</th>
					<th>Lab</th>
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
					    // INSERT the course attrs INTO the Course table
					    PreparedStatement pstmt = connection.prepareStatement(
					    ("INSERT INTO Course VALUES (?, ?)"));
					    
					    pstmt.setString(1, request.getParameter("cr_courseNumber"));
					    pstmt.setString(2, request.getParameter("cr_lab"));
					    
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
				    // UPDATE the student attributes in the Student table.
				    PreparedStatement pstatement = connection.prepareStatement(
				    "UPDATE Course SET cr_courseNumber = ?, cr_lab = ? WHERE cr_courseNumber = ?");
				    
				    pstatement.setString(1, request.getParameter("cr_courseNumber"));
				    pstatement.setString(2, request.getParameter("cr_lab"));
				    pstatement.setString(3, request.getParameter("cr_courseNumber"));
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
				    // DELETE the course FROM the COURSE table.
				    PreparedStatement pstmt = connection.prepareStatement(
				    "DELETE FROM Course WHERE cr_courseNumber = ?");
				    
				    pstmt.setString(1, request.getParameter("cr_courseNumber"));
				    int rowCount = pstmt.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
					
				<%
					Statement stmt = connection.createStatement();
				
					String GET_Course_QUERY = "SELECT * FROM Course";
					ResultSet rs = stmt.executeQuery(GET_Course_QUERY);
				%>
				
				<tr>
					<form action="Course.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="cr_courseNumber" size="10"></th>
						<th><input value="" name="cr_lab" size="10"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
					
				<%
					while (rs.next()) {    
				%>
				<%-- <tr>
					<!-- Get the course number -->
					<td><%= rs.getInt("cr_courseNumber") %></td>
					
					<!-- Get the lab -->
					<td><%= rs.getString("cr_lab") %></td>
				</tr> --%>
				<%
					}
				%>
				
				<%
				// Close the ResultSet
				rs.close();
				
				%>
				
				
				<!-- Iteration stuff? -->
				<%
				rs = stmt.executeQuery("SELECT * FROM course ORDER BY cr_courseNumber");
				
				while (rs.next()) {
				%>
				<tr>
					<form action="Course.jsp" method="get">
						<input type="hidden" value="update" name="action">
						<td><input value="<%= rs.getString("cr_courseNumber") %>" name="cr_courseNumber"></td>
						<td><input value="<%= rs.getString("cr_lab") %>" name="cr_lab"></td>
						<td><input type="submit" value="Update"></td>
					</form>
					<form action="Course.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= rs.getString("cr_courseNumber") %>" name="cr_courseNumber">
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
			create table Course (cr_courseNumber VARCHAR(255) PRIMARY KEY, cr_lab VARCHAR(255) NOT NULL);
			INSERT INTO course VALUES (123, 'yes');
			INSERT INTO course VALUES (456, 'no');
			INSERT INTO course VALUES (789, 'woohoo');
			*/
			%>
			
			
			<a href="./index.jsp">Back to Home Page</a>
			
</body>
</html>

