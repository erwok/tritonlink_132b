<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
// concentratio name
String name = request.getParameter("name");
%>
<title>Select Courses for Concentration in <%= name %></title>
</head>
<body>

<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<table>
				<tr>
					<th>Concentration Courses Entry</th>
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
					   
					    // Handle inserting prereqs into db
						String[] courses = request.getParameterValues("courses");
                        if (courses != null) {
	                        PreparedStatement pstmt = connection.prepareStatement(
	                            "INSERT INTO ConcentrationCourses VALUES (?, ?)");
	                        for(String c : courses) {
	                            pstmt.setString(1, name);
	                            pstmt.setString(2, c);
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
				    
				    PreparedStatement pstmt = connection.prepareStatement(
				    	"DELETE FROM ConcentrationCourses WHERE name = ? AND cr_courseNumber = ?"
					);
				    
				    pstmt.setString(1, name);
				    pstmt.setString(2, request.getParameter("cr_courseNumber"));
					pstmt.executeUpdate();
				    
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
					<form action="21_ConcentrationCourseSelection.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<input type="hidden" value="<%= name %>" name="name">
						<td><select multiple name="courses">
                            <option disabled>Select course(s)</option>
                            <%
                            while (rs.next()) {
                                String cr_courseNumber = rs.getString("cr_courseNumber");
                                %>
                                <option value="<%= cr_courseNumber %>"><%= cr_courseNumber %></option>
                                <%
                            } %>
                       	</select></td>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				
				
				<tr><td><h3>Courses under Concentration <%= name %></h3></td></tr>
				
				<%
					String GET_Concentration_Courses_Query = String.format("SELECT * FROM ConcentrationCourses WHERE name = '%s';", name);
					rs = stmt.executeQuery(GET_Concentration_Courses_Query);
				
					while (rs.next()) {
				%>
				<tr>
 					<td><%= rs.getString("cr_courseNumber") %></td>
					<form action="21_ConcentrationCourseSelection.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= name %>" name="name">
						<input type="hidden" value="<%= rs.getString("cr_courseNumber") %>" name="cr_courseNumber">
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
			<a href="./20_ConcentrationEntry.jsp">Back to Concentration page</a>
			<br>
			<a href="./00_index.jsp">Back to Home Page</a>


</body>
</html>