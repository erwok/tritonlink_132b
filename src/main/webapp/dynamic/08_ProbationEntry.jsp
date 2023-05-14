<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Probation Entry page</title>
</head>
<body>
			<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<b>Probation Entry Page</b>
			
			<table>
				<tr>
					<th>st_ID</th>
					<th>st_startDate</th>
					<th>st_endDate</th>
					<th>st_reason</th>
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
					    // INSERT the Probation attrs INTO the Probation table
					    PreparedStatement pstmt = connection.prepareStatement(
					    ("INSERT INTO Probation VALUES (?, ?, ?, ?)"));

					    pstmt.setString(1, request.getParameter("st_ID"));
					    pstmt.setString(2, request.getParameter("st_startDate"));
					    pstmt.setString(3, request.getParameter("st_endDate"));
					    pstmt.setString(4, request.getParameter("st_reason"));
					    
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
				    	"UPDATE Probation SET cr_ProbationNumber = ?, cr_lab = ? \n"+
				    	"WHERE cr_ProbationNumber = ?"
				    );

				    pstatement.setString(1, request.getParameter("cr_ProbationNumber"));
				    pstatement.setString(2, request.getParameter("cr_lab"));
				    pstatement.setString(3, request.getParameter("cr_ProbationNumber"));
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
				    // DELETE the Probation FROM the Probation table.
				    PreparedStatement pstmt = connection.prepareStatement(
				    	"DELETE FROM Probation \n"+
					    "WHERE cr_ProbationNumber = ?"
					);
				    
				    pstmt.setString(1, request.getParameter("cr_ProbationNumber"));
				    int rowCount = pstmt.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
					
				<%
					Statement stmt = connection.createStatement();
				
					String GET_Probation_QUERY = "SELECT * FROM Probation";
					ResultSet rs = stmt.executeQuery(GET_Probation_QUERY);
				%>
				
				<tr>
					<form action="08_ProbationEntry.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="cr_ProbationNumber" size="10"></th>
						<th><input value="" name="cr_lab" size="10"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
					
				<%
					while (rs.next()) {    
				%>
				<%-- <tr>
					<!-- Get the Probation number -->
					<td><%= rs.getInt("cr_ProbationNumber") %></td>
					
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
				rs = stmt.executeQuery(
					"SELECT * FROM Probation \n"+
					"ORDER BY cr_ProbationNumber"
				);
				
				while (rs.next()) {
				%>
				<tr>
					<form action="08_ProbationEntry.jsp" method="get">
						<input type="hidden" value="update" name="action">
						<td><input value="<%= rs.getString("cr_ProbationNumber") %>" name="cr_ProbationNumber"></td>
						<td><input value="<%= rs.getString("cr_lab") %>" name="cr_lab"></td>
						<td><input type="submit" value="Update"></td>
					</form>
					<form action="08_ProbationEntry.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= rs.getString("cr_ProbationNumber") %>" name="cr_ProbationNumber">
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
			create table Probation (cr_ProbationNumber VARCHAR(255) PRIMARY KEY, cr_lab VARCHAR(255) NOT NULL);
			INSERT INTO Probation VALUES (123, 'yes');
			INSERT INTO Probation VALUES (456, 'no');
			INSERT INTO Probation VALUES (789, 'woohoo');
			*/
			%>
			
			
			<a href="./00_index.jsp">Back to Home Page</a>
			
</body>
</html>
