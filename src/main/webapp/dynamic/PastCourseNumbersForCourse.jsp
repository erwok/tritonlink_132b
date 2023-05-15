<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String cn = request.getParameter("courseName");
%>
<title>Past course numbers for <%= cn %></title>
</head>
<body>

<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<h3>Past course numbers for <u><%= cn %></u></h3>
			
			<table>
				<tr>
					
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
					    
					    PreparedStatement pstmt = connection.prepareStatement(
					    ("INSERT INTO PastCourseNums VALUES (?, ?)"));

					    pstmt.setString(1, request.getParameter("cr_courseNumber"));
					    pstmt.setString(2, request.getParameter("oldCourseNumber"));
					    
					    pstmt.executeUpdate();
					    
					    connection.commit();
					    connection.setAutoCommit(true);
					}
				
				%>
				
				<%-- <!-- Update stuff? -->
				<%
				// Check if an update is requested
				if (action != null && action.equals("update")) {
				    
				    connection.setAutoCommit(false);
				    
				    PreparedStatement pstatement = connection.prepareStatement(
				        "UPDATE PastCourseNums SET oldCourseNumber = ? WHERE cr_courseNumber = ? AND oldCourseNumber = ?"
				    );
				    
				    pstatement.setString(1, request.getParameter("oldCourseNumber"));
				    pstatement.setString(2, request.getParameter("cr_courseNumber"));
				    pstatement.setString(3, request.getParameter("oldCourseNumber"));
				    
				    int rowCount = pstatement.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%> --%>
				
				<!-- Delete stuff? -->
				<%
				// Check if a delete is requested
				if (action != null && action.equals("delete")) {
				    
				    connection.setAutoCommit(false);
				    
				    PreparedStatement pstmt = connection.prepareStatement(
				        "DELETE FROM PastCourseNums WHERE cr_courseNumber = ? AND oldCourseNumber = ?"
				    );
				    
				    pstmt.setString(1, request.getParameter("cr_courseNumber"));
				    pstmt.setString(2, request.getParameter("oldCourseNumber"));
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
					<form action="PastCourseNumbersForCourse.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<input type="hidden" name="cr_courseNumber" value=<%= cn %>>
						<input type="hidden" name="courseName" value=<%= cn %>>
						<td><input value="" name="oldCourseNumber" size="10"></td>
						<td><input type="submit" value="Insert"></td>
					</form>
				</tr>
				
				<!-- Iteration stuff? -->
				<%
				rs = stmt.executeQuery(
			        "SELECT * FROM PastCourseNums WHERE cr_courseNumber = '" + cn + "'"
				);
				
				while (rs.next()) {
				%>
				<tr>
					<%-- <form action="PastCourseNumbersForCourse.jsp" method="get">
						<input type="hidden" value="update" name="action">
						<input type="hidden" name="cr_courseNumber" value=<%= cn %>>
						<input type="hidden" name="courseName" value=<%= cn %>>
						<td><input value="<%= rs.getString("oldCourseNumber") %>" name="oldCourseNumber"></td>
						<td><input type="submit" value="Update"></td>
					</form> --%>
					<td><%= rs.getString("oldCourseNumber") %></td>
					<form action="PastCourseNumbersForCourse.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" name="cr_courseNumber" value=<%= cn %>>
						<input type="hidden" name="courseName" value=<%= cn %>>
						<input type="hidden" value="<%= rs.getString("oldCourseNumber") %>" name="oldCourseNumber">
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
			<a href="./01_CourseEntry.jsp">Back to Course page</a>
			<br>
			<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>