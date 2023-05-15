<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Degree Reqs</title>
</head>
<body>

<%-- Set the scripting language Java and --%>
		<%@ page language="java" import="java.sql.*" %>
		<h3>Degree Requirements</u></h3>
		<table>
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
					   
                        PreparedStatement pstmt = connection.prepareStatement(
                        	"INSERT INTO Degree VALUES (?, ?, ?, ?)"
						);
                        pstmt.setString(1, request.getParameter("majorCode"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("requiredTotalUnits")));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("requiredLowerDivUnits")));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("requiredUpperDivUnits")));
                        pstmt.executeUpdate();
                        
                        connection.setAutoCommit(true);
					}
				%>
				
				<!-- Update stuff? -->
				<%
				// Check if an update is requested
				if (action != null && action.equals("update")) {
				    
				    connection.setAutoCommit(false);
				    
				    PreparedStatement pstatement = connection.prepareStatement(
				        "UPDATE Degree SET requiredTotalUnits = ?, requiredLowerDivUnits = ?, requiredUpperDivUnits = ?\n"+
				    	"WHERE majorCode = ?"
				    );
				    
				    pstatement.setInt(1, Integer.parseInt(request.getParameter("requiredTotalUnits")));
				    pstatement.setInt(2, Integer.parseInt(request.getParameter("requiredLowerDivUnits")));
				    pstatement.setInt(3, Integer.parseInt(request.getParameter("requiredUpperDivUnits")));
				    pstatement.setString(4, request.getParameter("majorCode"));
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
			            "DELETE FROM Degree WHERE majorCode = ?"
				    );
				    
				    pstmt.setString(1, request.getParameter("majorCode"));
				    int rowCount = pstmt.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
					
				<%
					Statement stmt = connection.createStatement();
					ResultSet rs;
				%>
				<tr>
					<th>Major Code</th>
					<th>Required Total Units</th>
					<th>Required Lower Div Units</th>
					<th>Required Upper Div Units</th>
				</tr>
				<tr>
					<form action="10_DegreeRequirementsEntry.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<td><input value="" name="majorCode"></td>
						<td><input value="" name="requiredTotalUnits"></td>
						<td><input value="" name="requiredLowerDivUnits"></td>
						<td><input value="" name="requiredUpperDivUnits"></td>
						<td><input type="submit" value="Insert"></td>
					</form>
				</tr>
					

				<!-- Iteration stuff? -->
				<%
				rs = stmt.executeQuery(
			    	"SELECT * FROM Degree"
		        );
				
				while (rs.next()) {
				%>
				<tr>
					<form action="10_DegreeRequirementsEntry.jsp" method="get">
						<input type="hidden" value="update" name="action">
						<td><input value="<%= rs.getString("majorCode") %>" name="majorCode"></td>
						<td><input value="<%= rs.getInt("requiredTotalUnits") %>" name="requiredTotalUnits"></td>
						<td><input value="<%= rs.getInt("requiredLowerDivUnits") %>" name="requiredLowerDivUnits"></td>
						<td><input value="<%= rs.getInt("requiredUpperDivUnits") %>" name="requiredUpperDivUnits"></td>
						<td><input type="submit" value="Update"></td>
					</form>
					<form action="10_DegreeRequirementsEntry.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= rs.getString("majorCode") %>" name="majorCode">
						<input type="hidden" value="<%= rs.getInt("requiredTotalUnits") %>" name="requiredTotalUnits">
						<input type="hidden" value="<%= rs.getInt("requiredLowerDivUnits") %>" name="requiredLowerDivUnits">
						<input type="hidden" value="<%= rs.getInt("requiredUpperDivUnits") %>" name="requiredUpperDivUnits">
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
			/* Experiment queries */
			
			/*
			CREATE TABLE Degree (
		        majorCode VARCHAR(255) PRIMARY KEY,
		        requiredTotalUnits INT NOT NULL,
		        requiredLowerDivUnits INT,
		        requiredUpperDivUnits INT
	        );
			
			
			
			*/
			
			%>
			
			<p></p>
			<br>
			<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>