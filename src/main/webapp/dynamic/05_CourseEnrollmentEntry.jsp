<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String studentID = request.getParameter("studentID");
String cn = request.getParameter("courseName");
String title = request.getParameter("classTitle");
String year = request.getParameter("classYear");
String quarter = request.getParameter("classQuarter");
String section = request.getParameter("sectionID");
%>
<title>Course Enrollment Entry Page</title>
</head>
<body>
			<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<b>Course Enrollment Entry Page</b>
			
			<table>
				<tr>
					<th>ID</th>
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
					    // INSERT the taker attrs INTO the taker table
					    PreparedStatement pstmt = connection.prepareStatement(
					    ("INSERT INTO taker VALUES (?)"));

					    pstmt.setString(1, request.getParameter("st_ID"));
					    
					    pstmt.executeUpdate();
					    
					    connection.commit();
                        connection.setAutoCommit(true);
					}
				
				%>
				
				<!-- Update stuff? -->
				<%
                    // no update
				%>
				
				<!-- Delete stuff? -->
				<%
				// Check if a delete is requested
				if (action != null && action.equals("delete")) {
				    
				    connection.setAutoCommit(false);
				    
				    // Create the prepared statement and use it to
				    // DELETE the taker FROM the taker table.
				    PreparedStatement pstmt = connection.prepareStatement(
				    	"DELETE FROM taker \n"+
				    	"WHERE st_ID = ?"
				    );
				    
				    pstmt.setString(1, request.getParameter("st_ID"));
				    int rowCount = pstmt.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
					
				<%
					Statement stmt = connection.createStatement();
				
					String GET_taker_QUERY = "SELECT * FROM taker";
					ResultSet rs = stmt.executeQuery(GET_taker_QUERY);
				%>
				
				<tr>
					<form action="05_CourseEnrollmentEntry.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="st_ID" size="10"></th>
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
					"SELECT * FROM taker \n"+
					"ORDER BY st_ID"
				);
				
				while (rs.next()) {
				%>
				<tr>
                    <td><%= rs.getString("st_ID") %></td>
					<form action="05_CourseEnrollmentEntry.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= rs.getString("st_ID") %>" name="st_ID">
						<td><input type="submit" value="Delete"></td>
					</form>
                    <% String sID = rs.getString("st_ID"); %>
					<td><button onclick="window.location.href='./13_EnrollingCoursesForEachStudents.jsp?studentID=<%= sID %>&courseName=<%= cn %>&classTitle=<%= title %>&classYear=<%= year %>&classQuarter=<%= quarter %>&sectionID=<%= rs.getString("s_sectionID")%>'">Enrollment</button></td>
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
			
			CREATE TABLE Student (
                st_ID VARCHAR(255) PRIMARY KEY, 
                st_SSN VARCHAR(255) UNIQUE NOT NULL,
			    st_enrollmentStatus VARCHAR(255) NOT NULL,
				st_residential VARCHAR(255) NOT NULL,
			    st_firstName VARCHAR(255) NOT NULL, 
				st_middleName VARCHAR(255), 
				st_lastName VARCHAR(255) NOT NULL
			);
			
            CREATE TABLE taker (
                st_ID VARCHAR(255) PRIMARY KEY, 
                CONSTRAINT FK_take_from_Student FOREIGN KEY (st_ID) REFERENCES Student(st_ID)
            );

            CREATE TABLE take (
                st_ID VARCHAR(255) NOT NULL, 
                s_sectionID VARCHAR(255) NOT NULL,
                take_enrollmentStatus INT NOT NULL, 
                take_gradingOption VARCHAR(255) NOT NULL,
                CONSTRAINT FK_take_from_Student FOREIGN KEY (st_ID) REFERENCES taker(st_ID),
                CONSTRAINT FK_take_from_Section FOREIGN KEY (s_sectionID) REFERENCES Section(s_sectionID)
            );
			
			*/
			%>
			
			
			<a href="./00_index.jsp">Back to Home Page</a>
			

</body>
</html>

