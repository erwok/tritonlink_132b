<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ThesisCommittee Entry page</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<b>ThesisCommittee Entry Page</b>
			
			<table>
				<tr>
					<th>ThesisCommittee ID</th>
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
					    // INSERT the ThesisCommittee attrs INTO the ThesisCommittee table
					    PreparedStatement pstmt = connection.prepareStatement(
					    ("INSERT INTO ThesisCommittee VALUES (?)"));
					    
					    pstmt.setString(1, request.getParameter("tc_ID"));
					    
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
				    // UPDATE the ThesisCommittee attributes in the ThesisCommittee table.
				    PreparedStatement pstatement = connection.prepareStatement(
				    	"UPDATE ThesisCommittee SET tc_ID = ? \n"+
				    	"WHERE tc_ID = ?"
				    );

				    pstatement.setString(1, request.getParameter("tc_ID"));
				    pstatement.setString(2, request.getParameter("tc_ID"));
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
				    // DELETE the ThesisCommittee FROM the ThesisCommittee table.
				    PreparedStatement pstmt = connection.prepareStatement(
				    	"DELETE FROM ThesisCommittee ThesisCommittee \n"+
						"WHERE tc_ID = ?"
					);
				    
				    pstmt.setString(1, request.getParameter("tc_ID"));
				    int rowCount = pstmt.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
					
				<%
					Statement stmt = connection.createStatement();
				
					String GET_ThesisCommittee_QUERY = "SELECT * FROM ThesisCommittee";
					ResultSet rs = stmt.executeQuery(GET_ThesisCommittee_QUERY);
				%>
				
				<tr>
					<form action="07_ThesisCommitteeEntry.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="tc_ID" size="10"></th>
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
					"SELECT * FROM ThesisCommittee \n"+
					"ORDER BY tc_ID"
				);
				
				while (rs.next()) {
				%>
				<tr>
					<form action="07_ThesisCommitteeEntry.jsp" method="get">
						<input type="hidden" value="update" name="action">
						<td><input value="<%= rs.getString("tc_ID") %>" name="tc_ID"></td>
						<td><input type="submit" value="Update"></td>
					</form>
					<form action="07_ThesisCommitteeEntry.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= rs.getString("tc_ID") %>" name="tc_ID">
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
			CREATE TABLE ThesisCommittee ( tc_ID VARCHAR(255) PRIMARY KEY);
			
			*/
			%>
			
			
			<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>

