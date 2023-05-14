<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Course Enrollment Entry Page</title>
</head>
<body>
			<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<b>Course Enrollment Entry Page</b>
			
			<table>
				<tr>
					<th>Student ID</th>
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

					    // Handle inserting student into db
						String[] students = request.getParameterValues("st_ID");
                        if (students != null) {
                        	String ** = request.getParameter("**");
	                        pstmt = connection.prepareStatement(
	                            "INSERT INTO ** VALUES (?, ?, ?)");
	                        for(String s : students) {
	                            pstmt.setString(1, ** + s);
		                        pstmt.setString(2, **);
		                        pstmt.setString(3, s);
		                        pstmt.executeUpdate();
	                        }s
	                        
	                        connection.commit();
                        }

					    // Create the prepared statement and use it to
					    // INSERT the class attrs INTO the Class table
					    PreparedStatement pstmt = connection.prepareStatement(
					    ("INSERT INTO Class VALUES (?, ?, ?, ?)"));
					    
					    pstmt.setString(1, request.getParameter("st_ID"));
					    pstmt.setString(2, request.getParameter("cl_title"));
					    pstmt.setInt(3, Integer.parseInt(request.getParameter("cl_year")));
					    pstmt.setString(4, request.getParameter("cl_quarter"));
					    
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
				    // UPDATE the class attributes in the Class table.
				    PreparedStatement pstatement = connection.prepareStatement(
				    	"UPDATE Class SET cl_title = ?, cl_year = ?, cl_quarter = ? \n"+
				    	"WHERE cl_title = ? AND cl_year = ? AND cl_quarter = ?");
					    
				    pstatement.setString(1, request.getParameter("cl_title"));
				    pstatement.setInt(2, Integer.parseInt(request.getParameter("cl_year")));
				    pstatement.setString(3, request.getParameter("cl_quarter"));
				    pstatement.setString(4, request.getParameter("cl_title"));
				    pstatement.setInt(5, Integer.parseInt(request.getParameter("cl_year")));
				    pstatement.setString(6, request.getParameter("cl_quarter"));
			    
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
				    // DELETE the class FROM the CLASS table.
				    PreparedStatement pstmt = connection.prepareStatement(
				    	"DELETE FROM Class \n"+
						"WHERE cl_title = ? AND cl_year = ? AND cl_quarter = ?"
					);
				    
				    pstmt.setString(1, request.getParameter("cl_title"));
				    pstmt.setInt(2, Integer.parseInt(request.getParameter("cl_year")));
				    pstmt.setString(3, request.getParameter("cl_quarter"));
				    int rowCount = pstmt.executeUpdate();
				    
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
					<form action="ClassEntry.jsp" method="get">
						<input type="hidden" value="insert" name="action">
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
					"SELECT * FROM class \n"+
					"ORDER BY cl_title, cl_year, cl_quarter"
				);
				
				while (rs.next()) {
				%>
				<tr>
					<form action="ClassEntry.jsp" method="get">
						<input type="hidden" value="update" name="action">
						<td><input value="<%= rs.getString("cl_title") %>" name="cl_title"></td>
						<td><input value="<%= rs.getInt("cl_year") %>" name="cl_year"></td>
						<td><input value="<%= rs.getString("cl_quarter") %>" name="cl_quarter"></td>
						<td><input type="submit" value="Update"></td>
					</form>
					<form action="ClassEntry.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= rs.getString("cl_title") %>" name="cl_title">
						<input type="hidden" value="<%= rs.getInt("cl_year") %>" name="cl_year">
						<input type="hidden" value="<%= rs.getString("cl_quarter") %>" name="cl_quarter">
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
			CREATE TABLE Class ( cl_title VARCHAR(255) NOT NULL, cl_year INT NOT NULL, cl_quarter VARCHAR(255) NOT NULL CONSTRAINT pk_ReviewSession_group PRIMARY KEY(cl_title, cl_year, cl_quarter));

			*/
			%>
			
			
			<a href="./index.jsp">Back to Home Page</a>

</body>
</html>

