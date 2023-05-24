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
%>
<title>Sections for <%= cn + " " + title + " " + quarter + year %></title>
</head>
<body>
		<%-- Set the scripting language Java and --%>
		<%@ page language="java" import="java.sql.*" %>
		<h3>Sections for <u><%= cn + " " + title + " " + quarter + year %></u></h3>
		<table>
				<tr>
					<th>SectionID</th>
					<th>Capacity</th>
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
					    	"INSERT INTO Section VALUES (?, ?, ?, ?, ?, ?)"
					    );
					    pstmt.setString(1, request.getParameter("s_sectionID"));
					    pstmt.setInt(2, Integer.parseInt(request.getParameter("s_capacity")));
					   	pstmt.setString(3, request.getParameter("cnum"));
					   	pstmt.setString(4, request.getParameter("title"));
					   	pstmt.setInt(5, Integer.parseInt(request.getParameter("year")));
					   	pstmt.setString(6, request.getParameter("quarter"));
					    
					    pstmt.executeUpdate();
					    
					    
					    /* if (Integer.parseInt(request.getParameter("year")) == 2023 &&
				            request.getParameter("quarter").equals("SP")) {
					        PreparedStatement pstmt2 = connection.prepareStatement(
				                "INSERT INTO CurrentCourses VALUES (?, ?, ?, ?, ?)"
			                );
					        pstmt2.setString(1, request.getParameter("cr_courseNumber"));
					        pstmt2.setString(2, request.getParameter("cl_title"));
					        pstmt2.setInt(3, Integer.parseInt(request.getParameter("cl_year")));
					        pstmt2.setString(4, request.getParameter("cl_quarter"));
					        pstmt2.setString(5, request.getParameter("s_sectionID"));
					        
					        pstmt2.executeUpdate();
					    } */
					    
					    connection.commit();
					    connection.setAutoCommit(true);
					}
				
				%>
				
				<!-- Update stuff? -->
				<%
				// Check if an update is requested
				if (action != null && action.equals("update")) {
				    
				    connection.setAutoCommit(false);
				    
				    PreparedStatement pstatement = connection.prepareStatement(
				        "UPDATE Section SET s_capacity = ? WHERE s_sectionID = ?"
				    );
				    
				    pstatement.setInt(1, Integer.parseInt(request.getParameter("s_capacity")));
				    pstatement.setString(2, request.getParameter("s_sectionID"));
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
				    
				    PreparedStatement pstmt6 = connection.prepareStatement(
		            	"DELETE FROM Take WHERE s_sectionID = ?"
		            );
				    pstmt6.setString(1, request.getParameter("s_sectionID"));
				    pstmt6.executeUpdate();
				    
				    PreparedStatement pstmt5 = connection.prepareStatement(
		            	"DELETE FROM CurrentCourses WHERE s_sectionID = ?"
		            );
				    pstmt5.setString(1, request.getParameter("s_sectionID"));
				    pstmt5.executeUpdate();
				    
				    PreparedStatement pstmt4 = connection.prepareStatement(
		            	"DELETE FROM ReviewSessions WHERE s_sectionID = ?"
		            );
				    pstmt4.setString(1, request.getParameter("s_sectionID"));
				    pstmt4.executeUpdate();
				    
				    
				    PreparedStatement pstmt3 = connection.prepareStatement(
			            "DELETE FROM WeeklyMeetings WHERE s_sectionID = ?"
		            );
				    pstmt3.setString(1, request.getParameter("s_sectionID"));
				    pstmt3.executeUpdate();
				    
				    PreparedStatement pstmt2 = connection.prepareStatement(
				    	"DELETE FROM Booklist WHERE s_sectionID = ?"
		            );
				    pstmt2.setString(1, request.getParameter("s_sectionID"));
				    pstmt2.executeUpdate();
				    
				    
				    PreparedStatement pstmt = connection.prepareStatement(
				        "DELETE FROM Section WHERE s_sectionID = ?"
				    );
				    pstmt.setString(1, request.getParameter("s_sectionID"));
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
					<form action="SectionsForClass.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="s_sectionID" size="10"></th>
						<th><input value="" name="s_capacity" size="10"></th>
						<input type="hidden" name="cnum" value="<%= cn %>">
						<input type="hidden" name="title" value="<%= title %>">
						<input type="hidden" name="year" value="<%= year %>">
						<input type="hidden" name="quarter" value="<%= quarter %>">
						<input type="hidden" name="courseName" value="<%= cn %>">
						<input type="hidden" name="classTitle" value="<%= title %>">
						<input type="hidden" name="classYear" value="<%= year %>">
						<input type="hidden" name="classQuarter" value="<%= quarter %>">
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
					

				<!-- Iteration stuff? -->
				<%
				rs = stmt.executeQuery(
				    "SELECT s_sectionID, s_capacity FROM Section \n"+
					"WHERE courseNumber = '" + cn + "' AND classTitle = '" + title + "' AND classYear = " + year + " AND classQuarter = '" + quarter + "' \n" +
					"ORDER BY s_sectionID"
				);
				
				while (rs.next()) {
				%>
				<tr>
					<form action="SectionsForClass.jsp" method="get">
						<input type="hidden" value="update" name="action">
						<td><input value="<%= rs.getString("s_sectionID") %>" name="s_sectionID"></td>
						<td><input value="<%= rs.getInt("s_capacity") %>" name="s_capacity"></td>
						<input type="hidden" name="courseName" value="<%= cn %>">
						<input type="hidden" name="classTitle" value="<%= title %>">
						<input type="hidden" name="classYear" value="<%= year %>">
						<input type="hidden" name="classQuarter" value="<%= quarter %>">
						<td><input type="submit" value="Update"></td>
					</form>
					<form action="SectionsForClass.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= rs.getString("s_sectionID") %>" name="s_sectionID">
						<input type="hidden" name="courseName" value="<%= cn %>">
						<input type="hidden" name="classTitle" value="<%= title %>">
						<input type="hidden" name="classYear" value="<%= year %>">
						<input type="hidden" name="classQuarter" value="<%= quarter %>">
						<td><input type="submit" value="Delete"></td>
					</form>
					<td><button onclick="window.location.href='./FacultyForSection.jsp?courseName=<%= cn %>&classTitle=<%= title %>&classYear=<%= year %>&classQuarter=<%= quarter %>&sectionID=<%= rs.getString("s_sectionID") %>'">Faculty</button></td> 
					<td><button onclick="window.location.href='./SectionWeeklyMeetings.jsp?courseName=<%= cn %>&classTitle=<%= title %>&classYear=<%= year %>&classQuarter=<%= quarter %>&sectionID=<%= rs.getString("s_sectionID") %>'">Weekly Meetings</button></td>
					<td><button onclick="window.location.href='./09_ReviewSessionInfoEntry.jsp?courseName=<%= cn %>&classTitle=<%= title %>&classYear=<%= year %>&classQuarter=<%= quarter %>&sectionID=<%= rs.getString("s_sectionID") %>'">Review Sessions</button></td>  
					<td><button onclick="window.location.href='./BooksForSection.jsp?courseName=<%= cn %>&classTitle=<%= title %>&classYear=<%= year %>&classQuarter=<%= quarter %>&sectionID=<%= rs.getString("s_sectionID") %>'">Booklist</button></td>    
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
			CREATE TABLE Section (
				s_sectionID VARCHAR(255) PRIMARY KEY, 
				s_capacity INT NOT NULL,
			    courseNumber VARCHAR(255) NOT NULL, 
				classTitle VARCHAR(255) NOT NULL, 
				classYear INT NOT NULL, 
				classQuarter VARCHAR(255) NOT NULL,
			    CONSTRAINT fk_cr FOREIGN KEY (courseNumber) REFERENCES Course(cr_courseNumber),
			    CONSTRAINT fk_cl FOREIGN KEY (classTitle, classYear, classQuarter) REFERENCES Class(cl_title, cl_year, cl_quarter),
			);
			
			// HOW I EVENTUALLY WANT TO HAVE IT IMPLEMENTED
			CREATE TABLE Section2 (
			    s_sectionID VARCHAR(255),
			    s_capacity INT NOT NULL,
			    courseNumber VARCHAR(255) NOT NULL,
			    classTitle VARCHAR(255) NOT NULL,
			    classYear INT NOT NULL,
			    classQuarter VARCHAR(255) NOT NULL,
			    CONSTRAINT pk_section PRIMARY KEY (s_sectionID, courseNumber, classTitle, classYear, classQuarter),
			    CONSTRAINT fk_cr FOREIGN KEY (courseNumber) REFERENCES Course(cr_courseNumber),
			    CONSTRAINT fk_cl FOREIGN KEY (classTitle, classYear, classQuarter) REFERENCES Class(cl_title, cl_year, cl_quarter)
			);
			
			CREATE TABLE Teaches (
				s_sectionID VARCHAR(255) NOT NULL, 
				fc_name VARCHAR(255) NOT NULL,
			    CONSTRAINT fk_s FOREIGN KEY (s_sectionID) REFERENCES Section(s_sectionID),
			    CONSTRAINT fk_fc FOREIGN KEY (fc_name) REFERENCES Faculty(fc_name)
			);
			
			CREATE TABLE Booklist (
				ISBN INT UNIQUE NOT NULL, 
				title VARCHAR(255) NOT NULL,
			    edition INT, 
				publisher VARCHAR(255), 
				author_fname VARCHAR(255), 
			    author_lname VARCHAR(255), 
				s_sectionID VARCHAR(255) NOT NULL,
			    CONSTRAINT fk_s_b FOREIGN KEY (s_sectionID) REFERENCES Section(s_sectionID)
				);
			
			CREATE TABLE WeeklyMeetings (
        		location VARCHAR(255) NOT NULL,
        		time VARCHAR(255) NOT NULL,
        		startTime VARCHAR(255),
        		endTime VARCHAR(255),
        		meetingType VARCHAR(255) NOT NULL,
        		daysOfWeek VARCHAR(255) NOT NULL,
        		attendanceType VARCHAR(255) NOT NULL,
        		s_sectionID VARCHAR(255) NOT NULL,
        		CONSTRAINT fk_wkm_s FOREIGN KEY (s_sectionID) REFERENCES SECTION(s_sectionID)
	        );
			
			CREATE TABLE ReviewSessions (
	        	location VARCHAR(255) NOT NULL,
	        	time VARCHAR(255) NOT NULL,
	        	startTime VARCHAR(255),
        		endTime VARCHAR(255),
	        	date VARCHAR(255) NOT NULL,
	        	s_sectionID VARCHAR(255) NOT NULL,
	        	CONSTRAINT fk_rvs_s FOREIGN KEY (s_sectionID) REFERENCES SECTION(s_sectionID)
	        );
			
			CREATE TABLE CurrentCourses (
				cr_courseNumber VARCHAR(255) NOT NULL, cl_title VARCHAR(255) NOT NULL,
				cl_year INT NOT NULL, cl_quarter VARCHAR(255) NOT NULL,
				s_sectionID VARCHAR(255) NOT NULL,
				CONSTRAINT fk_cc_cr FOREIGN KEY (cr_courseNumber) REFERENCES Course(cr_courseNumber),
				CONSTRAINT fk_cc_cl FOREIGN KEY (cl_title, cl_year, cl_quarter) REFERENCES Class(cl_title, cl_year, cl_quarter),
				CONSTRAINT fk_cc_s FOREIGN KEY (s_sectionID) REFERENCES Section(s_sectionID));
				
	        );
			*/
			%>
			
			<p></p>
			<br>
			<a href="./02_ClassEntry.jsp?courseName=<%= cn %>">Back</a>
			<br>
			<a href="./00_index.jsp">Back to Home Page</a>

			
			
			

</body>
</html>

