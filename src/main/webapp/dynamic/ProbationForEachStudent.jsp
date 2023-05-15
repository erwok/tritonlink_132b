<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String sID = request.getParameter("studentID");
%>
<title>Probation for <%= sID %></title>
</head>
<body>
			<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<b>Probation for <%= sID %></b>
			
			<table>
				<tr>
					<th>Student ID</th>
					<th>Start Date</th>
					<th>End Date</th>
					<th>Reason</th>
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
				
				
				<!-- Delete stuff? -->
				<%
				// Check if a delete is requested
				if (action != null && action.equals("delete")) {
				    
				    connection.setAutoCommit(false);
				    
				    // Create the prepared statement and use it to
				    // DELETE the Probation FROM the Probation table.
				    PreparedStatement pstmt = connection.prepareStatement(
				    	"DELETE FROM Probation \n"+
					    "WHERE st_ID = ? AND st_startDate = ? AND st_endDate = ? AND st_reason = ?"
					);
				    
				    pstmt.setString(1, request.getParameter("st_ID"));
					pstmt.setString(2, request.getParameter("st_startDate"));
					pstmt.setString(3, request.getParameter("st_endDate"));
					pstmt.setString(4, request.getParameter("st_reason"));
				    pstmt.executeUpdate();
				    
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
					<form action="ProbationForEachStudent.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="st_ID" size="10"></th>
						<th><input value="" name="st_startDate" size="10"></th>
						<th><input value="" name="st_endDate" size="10"></th>
						<th><input value="" name="st_reason" size="10"></th>
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
					"SELECT * FROM Probation \n"+
					"ORDER BY st_ID"
				);
				
				while (rs.next()) {
				%>
				<tr>
					<th><%= rs.getString("st_ID") %></th>
					<th><%= rs.getString("st_startDate") %></th>
					<th><%= rs.getString("st_endDate") %></th>
					<th><%= rs.getString("st_reason") %></th>
					<form action="ProbationForEachStudent.jsp" method="get">
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
			CREATE TABLE probator (
                st_ID VARCHAR(255) PRIMARY KEY, 
                CONSTRAINT FK_take_from_Student FOREIGN KEY (st_ID) REFERENCES Student(st_ID)
            );

			CREATE TABLE probation (
                st_ID VARCHAR(255) NOT NULL, 
                st_startDate VARCHAR(255) NOT NULL,
                st_endDate VARCHAR(255) NOT NULL, 
                st_reason VARCHAR(255) NOT NULL,
				CONSTRAINT PK_take PRIMARY KEY(st_ID, st_startDate, st_endDate, st_reason),
                CONSTRAINT FK_take_from_Student FOREIGN KEY (st_ID) REFERENCES probator(st_ID)
			);
			*/
			%>
			
			
			<a href="./00_index.jsp">Back to Home Page</a>
			
</body>
</html>
