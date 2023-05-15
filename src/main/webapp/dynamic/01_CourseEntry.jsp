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
					<th>Min Units</th>
					<th>Max Units</th>
					<th>Grade Option</th>
					<th>Lab</th>
					<th>Consent</th>
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
					    ("INSERT INTO Course VALUES (?, ?, ?, ?, ?, ?)"));
					    
					    pstmt.setString(1, request.getParameter("cr_courseNumber"));
					    pstmt.setInt(2, Integer.parseInt(request.getParameter("cr_minUnits")));
					    pstmt.setInt(3, Integer.parseInt(request.getParameter("cr_maxUnits")));
					    pstmt.setString(4, request.getParameter("cr_gradeOption"));
					    pstmt.setString(5, request.getParameter("cr_lab"));
					    pstmt.setString(6, request.getParameter("cr_consent"));
					    
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
				    	"UPDATE Course SET cr_minUnits = ?, cr_maxUnits = ?, cr_gradeOption = ?, \n"+
				    	"cr_lab = ?, cr_consent = ? \n"+
				    	"WHERE cr_courseNumber = ?"
				    );
				    
				    pstatement.setInt(1, Integer.parseInt(request.getParameter("cr_minUnits")));
				    pstatement.setInt(2, Integer.parseInt(request.getParameter("cr_maxUnits")));
				    pstatement.setString(3, request.getParameter("cr_gradeOption"));
				    pstatement.setString(4, request.getParameter("cr_lab"));
				    pstatement.setString(5, request.getParameter("cr_consent"));
				    pstatement.setString(6, request.getParameter("cr_courseNumber"));
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
				    
				    PreparedStatement pstmt2 = connection.prepareStatement(
				    	"DELETE FROM Courseoffering WHERE cr_courseNumber = ?"
				    );
				    pstmt2.setString(1, request.getParameter("cr_courseNumber"));
				    pstmt2.executeUpdate();
				    
				    PreparedStatement pstmt3 = connection.prepareStatement(
				    	"DELETE FROM Section WHERE courseNumber = ?"
				   	);
				    pstmt3.setString(1, request.getParameter("cr_courseNumber"));
				    pstmt3.executeUpdate();
				    
				    PreparedStatement pstmt5 = connection.prepareStatement(
		            	"DELETE FROM PastCourseNums WHERE cr_courseNumber = ?"
		            );
				    pstmt5.setString(1, request.getParameter("cr_courseNumber"));
				    pstmt5.executeUpdate();
				    
				    // Create the prepared statement and use it to
				    // DELETE the course FROM the COURSE table.
				    PreparedStatement pstmt4 = connection.prepareStatement(
				    	"DELETE FROM Course \n"+
					    "WHERE cr_courseNumber = ?"
					);
				    
				    pstmt4.setString(1, request.getParameter("cr_courseNumber"));
				    int rowCount = pstmt4.executeUpdate();
				    
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
						<td><input value="" name="cr_courseNumber" size="10"></td>
						<td><input value="" name="cr_minUnits" size="10"></td>
						<td><input value="" name="cr_maxUnits" size="10"></td>
                        <td><select name="cr_gradeOption">
                          <option value="letter" selected>Letter</option>
                          <option value="s/u">S/U</option>
                          <option value="both">both</option>
                        </select></td>
                        <td><select name="cr_lab">
                          <option value="no" selected>no</option>
                          <option value="yes">yes</option>
                        </select></td>
                        <td><select name="cr_consent">
                          <option value="no" selected>no</option>
                          <option value="yes">yes</option>
                        </select></td>
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
						<td><input value="<%= rs.getInt("cr_minUnits") %>" name="cr_minUnits" size="10"></td>
						<td><input value="<%= rs.getInt("cr_maxUnits") %>" name="cr_maxUnits" size="10"></td>
                        <td><select name="cr_gradeOption">
                       	  <% String go = rs.getString("cr_gradeOption"); %>
                          <option value="letter" <%= (go.equals("letter")) ? "selected":""%>>Letter</option>
                          <option value="s/u" <%= (go.equals("s/u")) ? "selected":""%>>S/U</option>
                          <option value="both" <%= (go.equals("both")) ? "selected":""%>>both</option>
                        </select></td>
                        <td><select name="cr_lab">
                          <% String lab = rs.getString("cr_lab"); %>
                          <option value="no" <%= (lab.equals("no")) ? "selected":""%>>no</option>
                          <option value="yes" <%= (go.equals("yes")) ? "selected":""%>>yes</option>
                        </select></td>
                        <td><select name="cr_consent">
                          <% String c = rs.getString("cr_consent"); %>
                          <option value="no" <%= (c.equals("no")) ? "selected":""%>>no</option>
                          <option value="yes" <%= (c.equals("yes")) ? "selected":""%>>yes</option>
                        </select></td>
						<td><input type="submit" value="Update"></td>
					</form>
					<form action="01_CourseEntry.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= rs.getString("cr_courseNumber") %>" name="cr_courseNumber">
						<td><input type="submit" value="Delete"></td>
					</form>
					<% String cn = rs.getString("cr_courseNumber"); %>
					<td><button onclick="window.location.href='./PastCourseNumbersForCourse.jsp?courseName=<%= cn %>'">Past Nums</button></td>
					<td><button onclick="window.location.href='./11_PrerequisitesEntryForEachMainCourse.jsp?courseName=<%= cn %>'">Prereqs</button></td>
					<td><button onclick="window.location.href='./02_ClassEntry.jsp?courseName=<%= cn %>'">Class Offerings</button></td>
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
			
			attributes: cr_courseNumber, cr_minUnits, cr_maxUnits, cr_gradeOption, cr_lab, cr_consent
			
			create table Course (cr_courseNumber VARCHAR(255) PRIMARY KEY, cr_minUnits INT NOT NULL,
		        cr_maxUnits INT NOT NULL, cr_gradeOption VARCHAR(255) NOT NULL, cr_lab VARCHAR(255),
		        cr_consent VARCHAR(255));
			
			create table Prerequisite (prerequisites_id VARCHAR(255) NOT NULL PRIMARY KEY, mainCourseNumber VARCHAR(255) NOT NULL, prerequisiteCourseNumber VARCHAR(255) NOT NULL, CONSTRAINT FK_PreCourse1 FOREIGN KEY (mainCourseNumber) REFERENCES Course(cr_courseNumber), CONSTRAINT FK_PreCourse2 FOREIGN KEY (prerequisiteCourseNumber) REFERENCES Course(cr_courseNumber));
			
			create table CourseOffering (cr_courseNumber VARCHAR(255) NOT NULL, cl_title VARCHAR(255) NOT NULL,
		        cl_year INT NOT NULL, cl_quarter VARCHAR(255) NOT NULL,
		        CONSTRAINT FK_cr1 FOREIGN KEY (cr_courseNumber) REFERENCES Course(cr_courseNumber),
		        CONSTRAINT FK_cl1 FOREIGN KEY (cl_title, cl_year, cl_quarter) REFERENCES Class(cl_title, cl_year, cl_quarter));
			
			// SAME 
	        create table CourseOffering (cr_courseNumber VARCHAR(255) NOT NULL, cl_title VARCHAR(255) NOT NULL, cl_year INT NOT NULL, cl_quarter VARCHAR(255) NOT NULL, CONSTRAINT FK_cr1 FOREIGN KEY (cr_courseNumber) REFERENCES Course(cr_courseNumber), CONSTRAINT FK_cl1 FOREIGN KEY (cl_title, cl_year, cl_quarter) REFERENCES Class(cl_title, cl_year, cl_quarter));
			
			create table PastCourseNums (cr_courseNumber VARCHAR(255) NOT NULL, oldCourseNumber VARCHAR(255),
				CONSTRAINT FK_pcn FOREIGN KEY (cr_courseNumber) REFERENCES Course(cr_courseNumber));
			*/
			%>
			
			
			<a href="./00_index.jsp">Back to Home Page</a>
			
</body>
</html>