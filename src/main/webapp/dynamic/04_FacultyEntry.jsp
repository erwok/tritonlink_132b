<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Faculty Entry Page</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<b>Faculty Entry Page</b>
			
			<table>
				<tr>
					<th>Name</th>
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
					    // INSERT the Faculty attrs INTO the Faculty table
					    PreparedStatement pstmt = connection.prepareStatement(
					    ("INSERT INTO Faculty VALUES (?)"));
					    
					    pstmt.setString(1, request.getParameter("fc_name"));
					    
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
				    // UPDATE the Faculty attributes in the Faculty table.
				    PreparedStatement pstatement = connection.prepareStatement(
				    	"UPDATE Faculty SET fc_name = ? \n"+
				    	"WHERE fc_name = ?"
				    );

				    pstatement.setString(1, request.getParameter("fc_name"));
				    pstatement.setString(2, request.getParameter("fc_name"));
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
				    
				    PreparedStatement pstmt2 = connection.prepareStatement(
				    	"DELETE FROM Teaches WHERE fc_name = ?"
	    	        );
				    pstmt2.setString(1, request.getParameter("fc_name"));
				    pstmt2.executeUpdate();
				    
				    // Create the prepared statement and use it to
				    // DELETE the Faculty FROM the Faculty table.
				    PreparedStatement pstmt = connection.prepareStatement(
				    	"DELETE FROM Faculty \n"+
						"WHERE fc_name = ?"
					);
				    pstmt.setString(1, request.getParameter("fc_name"));
				    int rowCount = pstmt.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
					
				<%
					Statement stmt = connection.createStatement();
				
					String GET_Faculty_QUERY = "SELECT * FROM Faculty";
					ResultSet rs = stmt.executeQuery(GET_Faculty_QUERY);
				%>
				
				<tr>
					<form action="04_FacultyEntry.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="fc_name" size="10"></th>
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
					"SELECT * FROM Faculty \n"+
					"ORDER BY fc_name"
				);
				
				while (rs.next()) {
				%>
				<tr>
					<form action="04_FacultyEntry.jsp" method="get">
						<input type="hidden" value="update" name="action">
						<td><input value="<%= rs.getString("fc_name") %>" name="fc_name"></td>
						<td><input type="submit" value="Update"></td>
					</form>
					<form action="04_FacultyEntry.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= rs.getString("fc_name") %>" name="fc_name">
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
			CREATE TABLE Faculty (fc_name VARCHAR(255) PRIMARY KEY);
			
			*/
			%>
			
			
			<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>

