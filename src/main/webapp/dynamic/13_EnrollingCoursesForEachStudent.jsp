<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String studentID = request.getParameter("studentID");
%>
<title>Course Enrollment for Student <%= studentID %></title>
</head>
<body>

<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<b>Enroll in the following classes</b>
			
			<table>
				<tr>
					<th>Course Number</th>
					<th>Class Title</th>
					<th>Class Year</th>
					<th>Class Quarter</th>
					<th>Section ID</th>
					<th>Enrollment Status</th>
					<th>Grading Option</th>
					<th>Units</th>
				</tr>
				<%
				try {
				    // Load driver
				    DriverManager.registerDriver(new org.postgresql.Driver());
				    
				    // Make a connection to the Oracle datasource
				    Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlink?user=postgres&password=helloworld");
				%>
				
				<!-- Insert stuff? -->
				<%
					// Check if an insertion is required
					String action = request.getParameter("action");
					if (action != null && action.equals("insert")) {
					    
					    connection.setAutoCommit(false);
					    
					    // Create the prepared statement and use it to
					    // INSERT the take attrs INTO the take table
					    /* PreparedStatement pstmt = connection.prepareStatement(
					    ("UPDATE take SET take_enrollmentStatus = ?, take_gradingOption = ? \n"+ 
					    "WHERE cr_courseNumber = ? AND cl_title = ? AND cl_year = ? AND cl_quarter = ? \n"+
					    "AND s_sectionID = ? AND st_id = ?")); */

					    PreparedStatement pstmt = connection.prepareStatement(
					    "INSERT INTO take VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)");
					    
					    pstmt.setString(1, request.getParameter("st_ID"));
					    pstmt.setString(2, request.getParameter("cr_courseNumber"));
					    pstmt.setString(3, request.getParameter("cl_title"));
					    pstmt.setInt(4, Integer.parseInt(request.getParameter("cl_year")));
					    pstmt.setString(5, request.getParameter("cl_quarter"));
					    pstmt.setString(6, request.getParameter("s_sectionID"));
					    pstmt.setString(7, request.getParameter("take_enrollmentStatus"));
					    pstmt.setString(8, request.getParameter("take_gradingOption"));
					    pstmt.setString(9, request.getParameter("take_units"));
					    
					    pstmt.executeUpdate();
					    
					    connection.commit();
                        connection.setAutoCommit(true);
					}
				
				%>
				
				<!-- Delete stuff? -->
				<%
				// Check if a delete is requested
				if (action != null && action.equals("delete")) {
				    
				    connection.setAutoCommit(false);
				    
				    PreparedStatement pstmt2 = connection.prepareStatement(
				    	"DELETE FROM take WHERE st_ID = ? AND cr_courseNumber = ? AND cl_title = ? \n"+
				    	"AND cl_year = ? AND cl_quarter = ? AND s_sectionID = ?"
		            );
				    pstmt2.setString(1, request.getParameter("st_ID"));
				    pstmt2.setString(2, request.getParameter("cr_courseNumber"));
				    pstmt2.setString(3, request.getParameter("cl_title"));
				    pstmt2.setInt(4, Integer.parseInt(request.getParameter("cl_year")));
				    pstmt2.setString(5, request.getParameter("cl_quarter"));
				    pstmt2.setString(6, request.getParameter("s_sectionID"));
				    pstmt2.executeUpdate();
				    
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
				<%
					Statement stmt = connection.createStatement();
				
					String GET_take_QUERY = "SELECT * FROM take";
					ResultSet rs = stmt.executeQuery(GET_take_QUERY);
				%>
				
				<tr>
					<form action="13_EnrollingCoursesForEachStudent.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<td><input value="" name="cr_courseNumber" size="10"></td>
						<td><input value="" name="cl_title" size="10"></td>
						<td><input value="2018" name="cl_year" size="10"></td>
						<td><input value="SPRING" name="cl_quarter" size="10"></td>
						<td><input value="" name="s_sectionID" size="10"></td>
						<td><input value="" name="take_enrollmentStatus" size="10"></td>
						<td><input value="" name="take_gradingOption" size="10"></td>
						<td><input value="" name="take_units" size="10"></td>
						<input type="hidden" name="st_ID" value="<%= studentID %>">
						<input type="hidden" name="studentID" value="<%= studentID %>">
						<td><input type="submit" value="Insert"></td>
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
				String getTake = "SELECT * FROM take WHERE st_id = '" + studentID + "';";
				rs = stmt.executeQuery(getTake);
				
				while (rs.next()) {
				%>
				    <tr>
				    	<td><%= rs.getString("cr_courseNumber") %></td>
				    	<td><%= rs.getString("cl_title") %></td>
				    	<td><%= rs.getInt("cl_year") %></td>
				    	<td><%= rs.getString("cl_quarter") %></td>
				    	<td><%= rs.getString("s_sectionID") %></td>
				    	<td><%= rs.getString("take_enrollmentStatus") %></td>
				    	<td><%= rs.getString("take_gradingOption") %></td>
				    	<td><%= rs.getString("take_units") %></td>
						<form action="13_EnrollingCoursesForEachStudent.jsp" method="get">
							<input type="hidden" value="delete" name="action">
							<input type="hidden" value="<%= studentID %>" name="st_ID">
							<input type="hidden" value="<%= rs.getString("cr_courseNumber") %>" name="cr_courseNumber">
							<input type="hidden" value="<%= rs.getString("cl_title") %>" name="cl_title">
							<input type="hidden" value="<%= rs.getString("cl_year") %>" name="cl_year">
							<input type="hidden" value="<%= rs.getString("cl_quarter") %>" name="cl_quarter">
							<input type="hidden" value="<%= rs.getString("s_sectionID") %>" name="s_sectionID">
							<input type="hidden" value="<%= rs.getString("take_enrollmentStatus") %>" name="take_enrollmentStatus">
							<input type="hidden" value="<%= rs.getString("take_gradingOption") %>" name="take_gradingOption">
							<input type="hidden" value="<%= rs.getString("take_units") %>" name="take_units">
							<td><input type="submit" value="Delete"></td>
						</form>
				    </tr>
				<%
				}
				%>
				
				
				<%
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
		
			<br>
			<a href="./05_CourseEnrollmentEntry.jsp">Back to student selection page</a>
			<br>
			<a href="./00_index.jsp">Back to Home Page</a>


		<%
		/* 
		CREATE TABLE CurrentCourses (
			cr_courseNumber VARCHAR(255) NOT NULL, cl_title VARCHAR(255) NOT NULL,
			cl_year INT NOT NULL, cl_quarter VARCHAR(255) NOT NULL,
			s_sectionID VARCHAR(255) NOT NULL,
			CONSTRAINT fk_cc_cr FOREIGN KEY (cr_courseNumber) REFERENCES Course(cr_courseNumber),
			CONSTRAINT fk_cc_cl FOREIGN KEY (cl_title, cl_year, cl_quarter) REFERENCES Class(cl_title, cl_year, cl_quarter),
			CONSTRAINT fk_cc_s FOREIGN KEY (s_sectionID) REFERENCES Section(s_sectionID));
        ); 
        
		CREATE TABLE taker (
	        st_ID VARCHAR(255) PRIMARY KEY, 
	        CONSTRAINT FK_take_from_Student FOREIGN KEY (st_ID) REFERENCES Student(st_ID)
	    );
	
		CREATE TABLE take (
            st_ID VARCHAR(255) NOT NULL, 
            cr_courseNumber VARCHAR(255) NOT NULL,
            cl_title VARCHAR(255) NOT NULL,
   			cl_year INT NOT NULL,
  			cl_quarter VARCHAR(255) NOT NULL,
  			s_sectionID VARCHAR(255) NOT NULL,
          	take_enrollmentStatus VARCHAR(255) NOT NULL, 
            take_gradingOption VARCHAR(255) NOT NULL,
            take_units VARCHAR(255) NOT NULL,
            CONSTRAINT FK_take_from_Student FOREIGN KEY (st_ID) REFERENCES taker(st_ID),
            CONSTRAINT fk_t_cr FOREIGN KEY (cr_courseNumber) REFERENCES Course(cr_courseNumber),
  			CONSTRAINT fk_t_cl FOREIGN KEY (cl_title, cl_year, cl_quarter) REFERENCES Class(cl_title, cl_year, cl_quarter),
            CONSTRAINT FK_take_from_Section FOREIGN KEY (s_sectionID) REFERENCES Section(s_sectionID)
        );
        */
		%>
</body>
</html>