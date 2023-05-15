<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String sID = request.getParameter("sID");
%>
<title>Thesis Committee Submission</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<b>Thesis Committee Submission for student <%= sID %></b>
			
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
					    
					    // Create the prepared statement and use it to
					    // INSERT the ThesisCommittee attrs INTO the ThesisCommittee table
					    PreparedStatement pstmt = connection.prepareStatement(
					    ("INSERT INTO ThesisCommittee VALUES (?, ?)"));
					    
					    pstmt.setString(1, request.getParameter("tc_ID"));
					    pstmt.setString(2, request.getParameter("st_ID"));
					    
					    pstmt.executeUpdate();
					    
					    connection.commit();
					    connection.setAutoCommit(true);
					}
				
				%>
				
				<!-- Update stuff? -->
				<%
				/* No updates */
				%>
				
				<!-- Delete stuff? -->
				<%
				// Check if a delete is requested
				if (action != null && action.equals("delete")) {
				    
				    connection.setAutoCommit(false);
				    
				    // Create the prepared statement and use it to
				    // DELETE the ThesisCommittee FROM the ThesisCommittee table.
				    PreparedStatement pstmt = connection.prepareStatement(
				    	"DELETE FROM ThesisCommittee WHERE tc_ID = ?"
					);
				    
				    pstmt.setString(1, request.getParameter("tc_ID"));
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
					<form action="07_ThesisCommitteeEntry.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="tc_ID" size="10"></th>
						<input type="hidden" name="st_ID" value="<%= sID %>">
						<input type="hidden" value=<%= sID %> name="sID">
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				
				
				<!-- Iteration stuff? -->
				<%
				rs = stmt.executeQuery(
					"SELECT * FROM ThesisCommittee \n"+
					"ORDER BY tc_ID, st_ID"
				);
				
				while (rs.next()) {
				%>
				<tr>
					<td><%= rs.getString("tc_ID") %></td>
					<form action="07_ThesisCommitteeEntry.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= rs.getString("tc_ID") %>" name="tc_ID">
						<input type="hidden" value=<%= sID %> name="st_ID">
						<input type="hidden" value=<%= sID %> name="sID">
						<td><input type="submit" value="Delete"></td>
					</form>
					<td><button onclick="window.location.href='./18_TCProfessors.jsp?sID=<%= sID %>&tcID=<%= rs.getString("tc_ID") %>'">Professors</button></td>
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
			CREATE TABLE ThesisCommittee (tc_ID VARCHAR(255) PRIMARY KEY, st_id VARCHAR(255) NOT NULL,
		        CONSTRAINT fk_tc_cand FOREIGN KEY (st_id) REFERENCES Candidate(st_id));
			
			*/
			
			/* 
			CREATE TABLE TCProfs (tc_ID VARCHAR(255) NOT NULL, fc_name VARCHAR(255) NOT NULL,
			        CONSTRAINT fk_tc_prof FOREIGN KEY (fc_name) REFERENCES Faculty(fc_name));
			
			*/
			%>
			
			
			<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>

