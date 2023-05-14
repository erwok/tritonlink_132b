<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String mainCourseNumber = request.getParameter("courseName");
%>
<title>Prerequisite Courses for <%= mainCourseNumber %></title>
</head>
<body>

<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<table>
				<tr>
					<th>Prerequisites Entry</th>
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
					   
					    // Handle inserting prereqs into db
						String[] prereqs = request.getParameterValues("prerequisites_id");
                        if (prereqs != null) {
                            mcn = request.getParameter("mainCourseNumber");
	                        PreparedStatement pstmt = connection.prepareStatement(
	                            "INSERT INTO Prerequisite VALUES (?, ?, ?)");
	                        for(String p : prereqs) {
	                            pstmt.setString(1, mcn + p);
		                        pstmt.setString(2, mcn);
		                        pstmt.setString(3, p);
		                        pstmt.executeUpdate();
	                        }
	                        
	                        connection.commit();
                        }
                        
                        connection.setAutoCommit(true);
					}
				
				%>
				
				<!-- Delete stuff? -->
				<%
				// Check if a delete is requested
				if (action != null && action.equals("delete")) {
				    
				    connection.setAutoCommit(false);
				    
				    // Create the prepared statement and use it to
				    // DELETE the course FROM the COURSE table.
				    mcn = request.getParameter("mainCourseNumber");
				    PreparedStatement pstmt = connection.prepareStatement(
				    	"DELETE FROM Prerequisite WHERE mainCourseNumber = ? AND prerequisiteCourseNumber = ?"
					);
				    
				    /* if (mainCourseNumber == null) {
				        out.println("mainCourseNumber is null");
				    } */
				    
				    pstmt.setString(1, mcn);
				    pstmt.setString(2, request.getParameter("prerequisiteCourseNumber"));
				    int rowCount = pstmt.executeUpdate();
				    
				    connection.commit();
				    
				    connection.setAutoCommit(true);
				}
				%>
				
					
				<%
					Statement stmt = connection.createStatement();
				
					String GET_Course_QUERY = "SELECT * FROM Course";
					ResultSet rs = stmt.executeQuery(GET_Course_QUERY);
				%>
				
				<tr>
					<form action="11_PrerequisitesEntry.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<input type="hidden" value="<%= mainCourseNumber %>" name="mainCourseNumber">
						<input type="hidden" name="courseName" value="<%= mainCourseNumber %>">
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
				
				
				<tr><td><h3>Prerequisites for <%= mainCourseNumber %></h3></td></tr>
				
				<%
					String GET_Prerequisites_Query = String.format("SELECT * FROM Prerequisite WHERE mainCourseNumber = '%s';", mainCourseNumber);
					rs = stmt.executeQuery(GET_Prerequisites_Query);
				
					while (rs.next()) {
				%>
				<tr>
 					<td><%= rs.getString("prerequisiteCourseNumber") %></td>
					<form action="11_PrerequisitesEntry.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= mainCourseNumber %>" name="mainCourseNumber">
						<input type="hidden" value="<%= rs.getString("prerequisiteCourseNumber") %>" name="prerequisiteCourseNumber">
						<input type="hidden" name="courseName" value="<%= mainCourseNumber %>">
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
			<a href="./01_CourseEntry.jsp">Back to Course page</a>
			<br>
			<a href="./00_index.jsp">Back to Home Page</a>


</body>
</html>