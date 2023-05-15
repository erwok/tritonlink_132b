<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String studentID = request.getParameter("st_ID");
%>
<title>Enrolling Courses for <%= studentID %></title>
</head>
<body>

<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<table>
				<tr>
					<th>Section ID</th>
					<th>Enrollment Status</th>
					<th>Grade Option</th>
				</tr>
				<%
				try {
				    // Load driver
				    DriverManager.registerDriver(new org.postgresql.Driver());
				    
				    // Make a connection to the Oracle datasource
				    Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlink?user=postgres&password=helloworld");
				%>
				
				<%
				String mcn;
				%>
				
				<!-- Insertion stuff? -->
				<%
					// Check if an insertion is required
					String action = request.getParameter("action");
					if (action != null && action.equals("insert")) {
					    
					    connection.setAutoCommit(false);
					   
						PreparedStatement pstmt = connection.prepareStatement(
							"INSERT INTO take VALUES (?, ?, ?, ?)"
						);

						pstmt.setString(1, request.getParameter("st_ID"));
						pstmt.setString(2, request.getParameter("s_sectionID"));
						pstmt.setString(3, request.getParameter("take_enrollmentStatus"));
						pstmt.setString(3, request.getParameter("take_gradingOption"));
						pstmt.executeUpdate();
						
						connection.commit();
					
                        
                        connection.setAutoCommit(true);
					}
				
				%>
				
				<!-- Delete stuff? 
				<%
				// Check if a delete is requested
				if (action != null && action.equals("delete")) {
				    
				    connection.setAutoCommit(false);
				    
				    // Create the prepared statement and use it to
				    // DELETE the course FROM the COURSE table.
				    mcn = request.getParameter("studentID");
				    PreparedStatement pstmt = connection.prepareStatement(
				    	"DELETE FROM take WHERE studentID = ? AND prerequisiteCourseNumber = ?"
					);
				    
				    /* if (studentID == null) {
				        out.println("studentID is null");
				    } */
				    
				    pstmt.setString(1, mcn);
				    pstmt.setString(2, request.getParameter("prerequisiteCourseNumber"));
				    int rowCount = pstmt.executeUpdate();
				    
				    connection.commit();
				    
				    connection.setAutoCommit(true);
				}
				%>
			-->
					
				<%
					Statement stmt = connection.createStatement();
				
					String GET_Course_QUERY = "SELECT * FROM Section";
					ResultSet rs = stmt.executeQuery(GET_Course_QUERY);
				%>
				
				<tr>
					<td><%= rs.getString("s_sectionID") %></td>
					<form action="13_EnrollingCoursesForEachStudents.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<input type="hidden" value="<%= studentID %>" name="studentID">
						<input type="hidden" name="st_ID" value="<%= studentID %>">
						<td><select multiple name="prerequisites_id">
                            <option disabled>Select course(s)</option>
                            <%
                            while (rs.next()) {
                                String s_sectionID = rs.getString("s_sectionID");
                                %>
                                <option value="<%=rs.getString("s_sectionID")%>"><%= s_sectionID %></option>
                                <%
                            } %>
                       	</select></td>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				
				
				<tr><td><h3>Prerequisites for <%= studentID %></h3></td></tr>
				
				<%
					String GET_Prerequisites_Query = String.format("SELECT * FROM take WHERE studentID = '%s';", studentID);
					rs = stmt.executeQuery(GET_Prerequisites_Query);
				
					while (rs.next()) {
				%>
				<tr>
 					<td><%= rs.getString("s_sectionID") %></td>
					<form action="13_EnrollingCoursesForEachStudents.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= studentID %>" name="studentID">
						<input type="hidden" value="<%= rs.getString("prerequisiteCourseNumber") %>" name="prerequisiteCourseNumber">
						<input type="hidden" name="st_ID" value="<%= studentID %>">						
						<th><input value="<%= rs.getString("take_enrollmentStatus") %>" name="take_enrollmentStatus" size="10"></th>
						<th><input value="<%= rs.getString("take_gradingOption") %>" name="take_gradingOption" size="10"></th>
						<td><input type="submit" value="Delete"></td>
					</form>
				</tr>
				<%
					}
				%>
				
				<%
				// Close the ResultSet
				rs.close();
			
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
			<a href="./05_CourseEnrollmentEntry.jsp">Back to Course page</a>
			<br>
			<a href="./00_index.jsp">Back to Home Page</a>


</body>
</html>