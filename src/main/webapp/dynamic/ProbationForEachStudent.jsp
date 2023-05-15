<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String sID = request.getParameter("studentID");
%>
<title>Probation for student with id: <%= sID %></title>
</head>
<body>
			<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<b>Probation for student with id: <%= sID %></b>
			
			<table>
				<tr>
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
				<%
				// Check if an update is requested
				if (action != null && action.equals("update")) {
				    
				    connection.setAutoCommit(false);

				    PreparedStatement pstatement = connection.prepareStatement(
				        "UPDATE Probation SET st_reason = ? WHERE st_ID = ? AND st_startDate = ? AND st_endDate = ?");
				    
				    pstatement.setString(1, request.getParameter("st_reason"));
				    pstatement.setString(2, request.getParameter("st_ID"));
				    pstatement.setString(3, request.getParameter("st_startDate"));
				    pstatement.setString(4, request.getParameter("st_endDate"));
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
						<input type="hidden" value="<%= sID %>" name="st_ID">
						<td><input value="" name="st_startDate" size="10"></td>
						<td><input value="" name="st_endDate" size="10"></td>
						<td><input value="" name="st_reason" size="10"></td>
						<input type="hidden" name="studentID" value="<%= sID %>">
						<td><input type="submit" value="Insert"></td>
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
					<form action="ProbationForEachStudent.jsp" method="get">
						<input type="hidden" value="update" name="action">
						<input type="hidden" value="<%= sID %>" name="st_ID">
						<td><input value="<%= rs.getString("st_startDate") %>" name="st_startDate"></td>
						<td><input value="<%= rs.getString("st_endDate") %>" name="st_endDate"></td>
						<td><input value="<%= rs.getString("st_reason") %>" name="st_reason"></td>
						<input type="hidden" name="studentID" value="<%= sID %>">
						<td><input type="submit" value="Update"></td>
					</form>
					<form action="ProbationForEachStudent.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" name="st_ID" value="<%= sID %>">
						<input type="hidden" name="st_startDate" value="<%= rs.getString("st_startDate") %>">
						<input type="hidden" name="st_endDate" value="<%= rs.getString("st_endDate") %>">
						<input type="hidden" name="st_reason" value="<%= rs.getString("st_reason") %>">
						<input type="hidden" name="studentID" value="<%= sID %>">
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
