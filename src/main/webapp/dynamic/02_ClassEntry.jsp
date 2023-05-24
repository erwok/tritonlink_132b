<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String cn = request.getParameter("courseName");
%>
<title>Class Offerings for <%= cn %></title>
</head>
<body>
			<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<b>Class offerings for <%= cn %></b>
			
			<table>
				<tr>
					<th>Title</th>
					<th>Year</th>
					<th>Quarter</th>
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
					    // INSERT the class attrs INTO the Class table
					    PreparedStatement pstmt = connection.prepareStatement(
					    ("INSERT INTO Class VALUES (?, ?, ?)"));
					    
					    pstmt.setString(1, request.getParameter("cl_title"));
					    pstmt.setInt(2, Integer.parseInt(request.getParameter("cl_year")));
					    pstmt.setString(3, request.getParameter("cl_quarter"));
					    
					    pstmt.executeUpdate();
					    
					    PreparedStatement pstmt2 = connection.prepareStatement(
					    ("INSERT INTO CourseOffering VALUES (?, ?, ?, ?)"));
					    
					    pstmt2.setString(1, request.getParameter("courseNumber"));
					    pstmt2.setString(2, request.getParameter("cl_title"));
					    pstmt2.setInt(3, Integer.parseInt(request.getParameter("cl_year")));
					    pstmt2.setString(4, request.getParameter("cl_quarter"));
					    
					    pstmt2.executeUpdate();
					    
					    connection.commit();
					    connection.setAutoCommit(true);
					}
				
				%>
				
				<!-- Update stuff? -->
				<%
				/* // Check if an update is requested
				if (action != null && action.equals("update")) {
				    
				    connection.setAutoCommit(false);
				    
				    PreparedStatement pstmt1 = connection.prepareStatement(
				        "DELETE FROM CourseOffering WHERE cl_title = ? AND cl_year = ? AND cl_quarter = ?");
				    pstmt1.setString(1, request.getParameter("cl_title"));
				    pstmt1.setInt(2, Integer.parseInt(request.getParameter("cl_year")));
				    pstmt1.setString(3, request.getParameter("cl_quarter"));
				    
				    // Create the prepared statement and use it to
				    // UPDATE the class attributes in the Class table.
				    PreparedStatement pstatement = connection.prepareStatement(
				    	"UPDATE Class SET cl_title = ?, cl_year = ?, cl_quarter = ? \n"+
				    	"WHERE cl_title = ?");
					    
				    pstatement.setString(1, request.getParameter("cl_title"));
				    pstatement.setInt(2, Integer.parseInt(request.getParameter("cl_year")));
				    pstatement.setString(3, request.getParameter("cl_quarter"));
				    pstatement.setString(4, request.getParameter("cl_title"));
				    int rowCount = pstatement.executeUpdate();
				    
				    PreparedStatement pstmt2 = connection.prepareStatement(
					    ("INSERT INTO CourseOffering VALUES (?, ?, ?, ?)"));
				    pstmt2.setString(1, request.getParameter("courseNumber"));
				    pstmt2.setString(2, request.getParameter("cl_title"));
				    pstmt2.setInt(3, Integer.parseInt(request.getParameter("cl_year")));
				    pstmt2.setString(4, request.getParameter("cl_quarter"));
			    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				} */
				%>
				
				<!-- Delete stuff? -->
				<%
				// Check if a delete is requested
				if (action != null && action.equals("delete")) {
				    
				    connection.setAutoCommit(false);
				    
				    /* PreparedStatement pstmt6 = connection.prepareStatement(
				    	"DELETE FROM Student_section \n"+
						"WHERE cl_title = ? AND cl_year = ? AND cl_quarter = ?"
					);
				    pstmt6.setString(1, request.getParameter("cl_title"));
				    pstmt6.setInt(2, Integer.parseInt(request.getParameter("cl_year")));
				    pstmt6.setString(3, request.getParameter("cl_quarter"));
				    pstmt6.executeUpdate(); */
				    
				    PreparedStatement pstmt5 = connection.prepareStatement(
				    	"DELETE FROM Take \n"+
						"WHERE cl_title = ? AND cl_year = ? AND cl_quarter = ?"
					);
				    pstmt5.setString(1, request.getParameter("cl_title"));
				    pstmt5.setInt(2, Integer.parseInt(request.getParameter("cl_year")));
				    pstmt5.setString(3, request.getParameter("cl_quarter"));
				    pstmt5.executeUpdate();
				    
				    PreparedStatement pstmt4 = connection.prepareStatement(
				    	"DELETE FROM CurrentCourses \n"+
						"WHERE cl_title = ? AND cl_year = ? AND cl_quarter = ?"
					);
				    pstmt4.setString(1, request.getParameter("cl_title"));
				    pstmt4.setInt(2, Integer.parseInt(request.getParameter("cl_year")));
				    pstmt4.setString(3, request.getParameter("cl_quarter"));
				    pstmt4.executeUpdate();
				    
				    PreparedStatement pstmt1 = connection.prepareStatement(
				    	"DELETE FROM CourseOffering \n"+
						"WHERE cl_title = ? AND cl_year = ? AND cl_quarter = ?"
					);
				    
				    pstmt1.setString(1, request.getParameter("cl_title"));
				    pstmt1.setInt(2, Integer.parseInt(request.getParameter("cl_year")));
				    pstmt1.setString(3, request.getParameter("cl_quarter"));
				    pstmt1.executeUpdate();
				    
				    PreparedStatement pstmt2 = connection.prepareStatement(
			            "DELETE FROM Section \n"+
				    	"WHERE classTitle = ? AND classYear = ? AND classQuarter = ?"
				    );
				    pstmt2.setString(1, request.getParameter("cl_title"));
				    pstmt2.setInt(2, Integer.parseInt(request.getParameter("cl_year")));
				    pstmt2.setString(3, request.getParameter("cl_quarter"));
				    pstmt2.executeUpdate();
				    
				    // Create the prepared statement and use it to
				    // DELETE the class FROM the CLASS table.
				    PreparedStatement pstmt3 = connection.prepareStatement(
				    	"DELETE FROM Class \n"+
						"WHERE cl_title = ? AND cl_year = ? AND cl_quarter = ?"
					);
				    
				    pstmt3.setString(1, request.getParameter("cl_title"));
				    pstmt3.setInt(2, Integer.parseInt(request.getParameter("cl_year")));
				    pstmt3.setString(3, request.getParameter("cl_quarter"));
				    int rowCount = pstmt3.executeUpdate();
				    
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
					
				<%
					Statement stmt = connection.createStatement();
				
					String GET_Class_QUERY = "SELECT * FROM Class";
					ResultSet rs = stmt.executeQuery(GET_Class_QUERY);
				%>
				
				<tr>
					<form action="02_ClassEntry.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<input type="hidden" name="courseNumber" value="<%= cn %>">
						<input type="hidden" name="courseName" value="<%= cn %>">
						<th><input value="" name="cl_title" size="10"></th>
						<th><input value="" name="cl_year" size="10"></th>
						<th><input value="" name="cl_quarter" size="10"></th>
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
					"SELECT cl_year, cl_quarter, cl_title FROM CourseOffering \n"+
					"WHERE cr_courseNumber = '" + cn + "' \n" +
					"ORDER BY cl_year, cl_quarter, cl_title"
				);
				
				while (rs.next()) {
				%>
				<tr>
					<%-- <form action="02_ClassEntry.jsp" method="get">
						<input type="hidden" value="update" name="action">
						<td><input value="<%= rs.getString("cl_title") %>" name="cl_title"></td>
						<td><input value="<%= rs.getInt("cl_year") %>" name="cl_year"></td>
						<td><input value="<%= rs.getString("cl_quarter") %>" name="cl_quarter"></td>
						<input type="hidden" name="courseName" value="<%= cn %>">
						<td><input type="submit" value="Update"></td>
					</form> --%>
					<td><%= rs.getString("cl_title") %></td>
					<td><%= rs.getInt("cl_year") %></td>
					<td><%= rs.getString("cl_quarter") %></td>
					<form action="02_ClassEntry.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= rs.getString("cl_title") %>" name="cl_title">
						<input type="hidden" value="<%= rs.getInt("cl_year") %>" name="cl_year">
						<input type="hidden" value="<%= rs.getString("cl_quarter") %>" name="cl_quarter">
						<input type="hidden" name="courseName" value="<%= cn %>">
						<td><input type="submit" value="Delete"></td>
					</form>
					<td><button onclick="window.location.href='./SectionsForClass.jsp?courseName=<%= cn %>&classTitle=<%= rs.getString("cl_title") %>&classYear=<%= rs.getInt("cl_year") %>&classQuarter=<%= rs.getString("cl_quarter") %>'">Sections</button></td>
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
			CREATE TABLE Class (cl_title VARCHAR(255) NOT NULL, cl_year INT NOT NULL, cl_quarter VARCHAR(255) NOT NULL, CONSTRAINT pk_Class PRIMARY KEY(cl_title, cl_year, cl_quarter));

			*/
			%>
			
			<p></p>
			<br>
			<a href="./01_CourseEntry.jsp">Back to Course page</a>
			<br>
			<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>

