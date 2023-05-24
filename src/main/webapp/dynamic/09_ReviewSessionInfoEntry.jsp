<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String cn = request.getParameter("courseName");
String title = request.getParameter("classTitle");
String year = request.getParameter("classYear");
String quarter = request.getParameter("classQuarter");
String section = request.getParameter("sectionID");
%>
<title>Review Sessions for <%= cn + " " + title + " " + quarter + year + " section " + section %></title>
</head>
<body>

<%-- Set the scripting language Java and --%>
		<%@ page language="java" import="java.sql.*" %>
		<h3>Review Sessions for <u><%= cn + " " + title + " " + quarter + year + " section " + section %></u></h3>
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
                        	"INSERT INTO ReviewSessions VALUES (?, ?, ?, ?, ?, ?)"
						);
                        pstmt.setString(1, request.getParameter("location"));
                        pstmt.setString(2, request.getParameter("time"));
                        pstmt.setString(3, request.getParameter("date"));
                        pstmt.setString(4, request.getParameter("s_sectionID"));
                        pstmt.setString(5, request.getParameter("endTime"));
                        pstmt.setString(6, request.getParameter("startTime"));
                        pstmt.executeUpdate();
                        
                        connection.setAutoCommit(true);
					}
				%>
				
				<!-- Update stuff? -->
				<%
				/* NONE */
				%>
				
				<!-- Delete stuff? -->
				<%
				// Check if a delete is requested
				if (action != null && action.equals("delete")) {
				    
				    connection.setAutoCommit(false);
				    
				    PreparedStatement pstmt = connection.prepareStatement(
				        "DELETE FROM ReviewSessions WHERE s_sectionID = ? AND location = ? AND time = ? AND date = ?"
				    );
				    
				    pstmt.setString(1, request.getParameter("s_sectionID"));
				    pstmt.setString(2, request.getParameter("location"));
				    pstmt.setString(3, request.getParameter("time"));
				    pstmt.setString(4, request.getParameter("date"));
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
					<th>Location</th>
					<th>Time</th>
					<th>Date</th>
					<th>Start Time</th>
					<th>End Time</th>
				</tr>
				<tr>
					<form action="09_ReviewSessionInfoEntry.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<input type="hidden" value="<%= section %>" name="s_sectionID">
						<td><input value="" name="location"></td>
						<td><input value="" name="time"></td>
						<td><input value="" name="date"></td>
						<td><input value="" name="startTime"></td>
						<td><input value="" name="endTime"></td>
                       	<input type="hidden" name="courseName" value="<%= cn %>">
						<input type="hidden" name="classTitle" value="<%= title %>">
						<input type="hidden" name="classYear" value="<%= year %>">
						<input type="hidden" name="classQuarter" value="<%= quarter %>">
						<input type="hidden" name="sectionID" value="<%= section %>">
						<td><input type="submit" value="Insert"></td>
					</form>
				</tr>
					

				<!-- Iteration stuff? -->
				<%
				rs = stmt.executeQuery(
			    	"SELECT * FROM ReviewSessions WHERE s_sectionID = '" + section + "'"
		        );
				
				while (rs.next()) {
				%>
				<tr>
					<td><input value="<%= rs.getString("location") %>" name="location"></td>
					<td><input value="<%= rs.getString("time") %>" name="time"></td>
					<td><input value="<%= rs.getString("date") %>" name="date"></td>
					<td><input value="<%= rs.getString("startTime") %>" name="startTime"></td>
					<td><input value="<%= rs.getString("endTime") %>" name="endTime"></td>
					<form action="09_ReviewSessionInfoEntry.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= section %>" name="s_sectionID">
						<input type="hidden" value="<%= rs.getString("location") %>" name="location">
						<input type="hidden" value="<%= rs.getString("time") %>" name="time">
						<input type="hidden" value="<%= rs.getString("startTime") %>" name="startTime">
						<input type="hidden" value="<%= rs.getString("endTime") %>" name="endTime">
						<input type="hidden" value="<%= rs.getString("date") %>" name="date">
						<input type="hidden" name="courseName" value="<%= cn %>">
						<input type="hidden" name="classTitle" value="<%= title %>">
						<input type="hidden" name="classYear" value="<%= year %>">
						<input type="hidden" name="classQuarter" value="<%= quarter %>">
						<input type="hidden" name="sectionID" value="<%= section %>">
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
			
			<p></p>
			<br>
			<a href="./SectionsForClass.jsp?courseName=<%= cn %>&classTitle=<%= title %>&classYear=<%= year %>&classQuarter=<%= quarter %>">Back</a>
			<br>
			<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>