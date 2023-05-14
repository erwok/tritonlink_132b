<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Course Entry Page</title>
</head>
<body>
			<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<b>Course Entry Page</b>
			
			<table>
				<tr>
					<th>Course Number</th>
					<th>Lab</th>
					<th>Prerequisites</th>
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
					    // INSERT the course attrs INTO the Course table
					    PreparedStatement pstmt = connection.prepareStatement(
					    ("INSERT INTO Course VALUES (?, ?)"));
					    
					    pstmt.setString(1, request.getParameter("cr_courseNumber"));
					    pstmt.setString(2, request.getParameter("cr_lab"));
					    
					    pstmt.executeUpdate();
					    
					    connection.commit();
						
					    // Handle inserting prereqs into db
						String[] prereqs = request.getParameterValues("prerequisites_id");
                        if (prereqs != null) {
                        	String cr_courseNumber = request.getParameter("cr_courseNumber");
	                        pstmt = connection.prepareStatement(
	                            "INSERT INTO Prerequisite VALUES (?, ?, ?)");
	                        for(String p : prereqs) {
	                            pstmt.setString(1, cr_courseNumber + p);
		                        pstmt.setString(2, cr_courseNumber);
		                        pstmt.setString(3, p);
		                        pstmt.executeUpdate();
	                        }
	                        
	                        connection.commit();
                        }
                        
                        connection.setAutoCommit(true);
					}
				
				%>
				
				<!-- Update stuff? -->
				<%
				// Check if an update is requested
				if (action != null && action.equals("update")) {
				    
				    connection.setAutoCommit(false);
				    
				    // Create the prepared statement and use it to
				    // UPDATE the student attributes in the Student table.
				    PreparedStatement pstatement = connection.prepareStatement(
				    	"UPDATE Course SET cr_courseNumber = ?, cr_lab = ? \n"+
				    	"WHERE cr_courseNumber = ?"
				    );
				    
				    pstatement.setString(1, request.getParameter("cr_courseNumber"));
				    pstatement.setString(2, request.getParameter("cr_lab"));
				    pstatement.setString(3, request.getParameter("cr_courseNumber"));
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
				    
				    PreparedStatement pstmt1 = connection.prepareStatement(
				    	"DELETE FROM Prerequisite \n"+
						"WHERE mainCourseNumber = ? OR prerequisiteCourseNumber = ?"
				    );
				    pstmt1.setString(1, request.getParameter("cr_courseNumber"));
				    pstmt1.setString(2, request.getParameter("cr_courseNumber"));
				    pstmt1.executeUpdate();
				    
				    // Create the prepared statement and use it to
				    // DELETE the course FROM the COURSE table.
				    PreparedStatement pstmt2 = connection.prepareStatement(
				    	"DELETE FROM Course \n"+
					    "WHERE cr_courseNumber = ?"
					);
				    
				    pstmt2.setString(1, request.getParameter("cr_courseNumber"));
				    int rowCount = pstmt2.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
					
				<%
					Statement stmt = connection.createStatement();
				
					String GET_Course_QUERY = "SELECT * FROM Course";
					ResultSet rs = stmt.executeQuery(GET_Course_QUERY);
				%>
				
				<tr>
					<form action="01_CourseEntry.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="cr_courseNumber" size="10"></th>
						<th><input value="" name="cr_lab" size="10"></th>
						<td><select multiple name="prerequisites_id">
                            <option disabled>Select course(s)</option>
                            <%
                            while (rs.next()) {
                                String cr_courseNumber = rs.getString("cr_courseNumber");
                                %>
                                <option value="<%=rs.getString("cr_courseNumber")%>"><%= cr_courseNumber %></option>
                                <%
                            } %>
                       	</select></td>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
					
				<%
					while (rs.next()) {    
				%>
				<%-- <tr>
					<!-- Get the course number -->
					<td><%= rs.getInt("cr_courseNumber") %></td>
					
					<!-- Get the lab -->
					<td><%= rs.getString("cr_lab") %></td>
				</tr> --%>
				<%
					}
				%>
				
				<%
				// Close the ResultSet
				rs.close();
				
				%>
				
				
				<!-- Iteration stuff? -->
				<%
				rs = stmt.executeQuery(
					"SELECT * FROM course \n"+
					"ORDER BY cr_courseNumber"
				);
				
				while (rs.next()) {
				%>
				<tr>
					<form action="01_CourseEntry.jsp" method="get">
						<input type="hidden" value="update" name="action">
						<td><input value="<%= rs.getString("cr_courseNumber") %>" name="cr_courseNumber"></td>
						<td><input value="<%= rs.getString("cr_lab") %>" name="cr_lab"></td>
						<td><input type="submit" value="Update"></td>
					</form>
					<form action="01_CourseEntry.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= rs.getString("cr_courseNumber") %>" name="cr_courseNumber">
						<td><input type="submit" value="Delete"></td>
					</form>
					<% String cn = rs.getString("cr_courseNumber"); %>
					<td><button onclick="window.location.href='./11_PrerequisitesEntryForEachMainCourse.jsp?courseName=<%= cn %>'">Prereqs</button></td>
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
			create table Course (cr_courseNumber VARCHAR(255) PRIMARY KEY, cr_lab VARCHAR(255) NOT NULL);
			
			create table Prerequisite (prerequisites_id VARCHAR(255) NOT NULL PRIMARY KEY, mainCourseNumber VARCHAR(255) NOT NULL, prerequisiteCourseNumber VARCHAR(255) NOT NULL, CONSTRAINT FK_PreCourse1 FOREIGN KEY (mainCourseNumber) REFERENCES Course(cr_courseNumber), CONSTRAINT FK_PreCourse2 FOREIGN KEY (prerequisiteCourseNumber) REFERENCES Course(cr_courseNumber));
			*/
			%>
			
			
			<a href="./00_index.jsp">Back to Home Page</a>
			
</body>
</html>
