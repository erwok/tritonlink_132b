<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String studentID = request.getParameter("studentID");
%>
<title>Probation Entry page</title>
</head>
<body>
			<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<b>Probation Entry Page</b>
			
			<table>
				<tr>
					<th>Student ID</th>
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
					    // INSERT the Probator attrs INTO the Probator table
					    PreparedStatement pstmt = connection.prepareStatement(
					    ("INSERT INTO Probator VALUES (?)"));

					    pstmt.setString(1, request.getParameter("st_ID"));
					    
					    pstmt.executeUpdate();
					    
					    connection.commit();
					    connection.setAutoCommit(true);
					}
				
				%>
				
				<!-- Update stuff? -->
				<%
                    // no update
				%>
				
				<!-- Delete stuff? -->
				<%
				// Check if a delete is requested
				if (action != null && action.equals("delete")) {

					connection.setAutoCommit(false);
 
				    PreparedStatement pstmt1 = connection.prepareStatement(
				    	"DELETE FROM Probation \n"+
					    "WHERE st_ID = ?"
					);
				    pstmt1.setString(1, request.getParameter("st_ID"));
				    pstmt1.executeUpdate();

				    PreparedStatement pstmt2 = connection.prepareStatement(
				    	"DELETE FROM Probator \n"+
					    "WHERE st_ID = ?"
					);
				    
				    pstmt2.setString(1, request.getParameter("st_ID"));
				    pstmt2.executeUpdate();
				    
					connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
				<%
					Statement stmt = connection.createStatement();
				
					String GET_Probator_QUERY = "SELECT * FROM Probator";
					ResultSet rs = stmt.executeQuery(GET_Probator_QUERY);
				%>

				<tr>
					<form action="08_ProbationEntry.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="st_ID" size="10"></th>
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
					"SELECT * FROM Probator \n"+
					"ORDER BY st_ID"
				);
				
				while (rs.next()) {
				%>
				<tr>
                    <td><%= rs.getString("st_ID") %></td>
					<form action="08_ProbationEntry.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= rs.getString("st_ID") %>" name="st_ID">
						<td><input type="submit" value="Delete"></td>
					</form>
                    <% String sID = rs.getString("st_ID"); %>
					<td><button onclick="window.location.href='./ProbationForEachStudent.jsp?studentID=<%= sID %>'">Enrollment</button></td>
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

			CREATE TABLE Probation (
                st_ID VARCHAR(255) NOT NULL, 
                st_startDate VARCHAR(255) NOT NULL,
                st_endDate VARCHAR(255) NOT NULL, 
                st_reason VARCHAR(255) NOT NULL,
                CONSTRAINT FK_take_from_Student FOREIGN KEY (st_ID) REFERENCES probator(st_ID)
			);
			*/
			%>
			
			
			<a href="./00_index.jsp">Back to Home Page</a>
			
</body>
</html>
