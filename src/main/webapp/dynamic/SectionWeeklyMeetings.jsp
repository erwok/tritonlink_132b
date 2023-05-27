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
String section = request.getParameter("sectionID");
%>
<title>Weekly Meetings for <%= cn + " " + title + " " + quarter + year + " section " + section %></title>
</head>
<body>

<%-- Set the scripting language Java and --%>
		<%@ page language="java" import="java.sql.*" %>
		<h3>Weekly Meetings for <u><%= cn + " " + title + " " + quarter + year + " section " + section %></u></h3>
		<table>
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
                        	"INSERT INTO WeeklyMeetings VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
						);
                        pstmt.setString(1, request.getParameter("location"));
                        pstmt.setString(2, request.getParameter("time"));
                        pstmt.setString(3, request.getParameter("startTime"));
                        pstmt.setString(4, request.getParameter("endTime"));
                        pstmt.setString(5, request.getParameter("meetingType"));
                        pstmt.setString(6, request.getParameter("daysOfWeek"));
                        pstmt.setString(7, request.getParameter("attendanceType"));
                        pstmt.setString(8, request.getParameter("s_sectionID"));
                        pstmt.executeUpdate();
                        
                        connection.setAutoCommit(true);
					}
				%>
				
				<!-- Update stuff? -->
				<%
				// Check if an update is requested
				if (action != null && action.equals("update")) {
				    
				    connection.setAutoCommit(false);

				    PreparedStatement pstatement = connection.prepareStatement(
				        "UPDATE WeeklyMeetings SET attendanceType = ?, meetingType = ?\n" +
		                "WHERE location = ? AND time = ? AND startTime = ? AND endTime = ? AND daysOfWeek = ? AND s_sectionID = ?");
				    
				    pstatement.setString(1, request.getParameter("attendanceType"));
				    pstatement.setString(2, request.getParameter("meetingType"));
				    pstatement.setString(3, request.getParameter("location"));
				    pstatement.setString(4, request.getParameter("time"));
				    pstatement.setString(5, request.getParameter("startTime"));
				    pstatement.setString(6, request.getParameter("endTime"));
				    pstatement.setString(7, request.getParameter("daysOfWeek"));
				    pstatement.setString(8, request.getParameter("s_sectionID"));
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
				    
				    PreparedStatement pstmt = connection.prepareStatement(
				        "DELETE FROM WeeklyMeetings WHERE s_sectionID = ? AND location = ? AND time = ? AND daysOfWeek = ?"
				    );
				    
				    pstmt.setString(1, request.getParameter("s_sectionID"));
				    pstmt.setString(2, request.getParameter("location"));
				    pstmt.setString(3, request.getParameter("time"));
				    pstmt.setString(4, request.getParameter("daysOfWeek"));
				    int rowCount = pstmt.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
					
				<%
					Statement stmt = connection.createStatement();
					ResultSet rs;
					ResultSet rs2;
				%>
				<tr>
					<th>Location</th>
					<th>Time</th>
					<th>Start Time</th>
					<th>End Time</th>
					<th>Start Date</th>
					<th>End Date</th>
					<th>Days Of Week</th>
					<th>Meeting Type</th>
					<th>Attendance Type</th>
				</tr>
				<tr>
					<form action="SectionWeeklyMeetings.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<input type="hidden" value="<%= section %>" name="s_sectionID">
						<td><input value="" name="location"></td>
						<td><input value="" name="time"></td>
						<td><input value="" name="startTime"></td>
						<td><input value="" name="endTime"></td>
						<%
						rs2 = stmt.executeQuery(
					        "SELECT * \n" +
							"FROM QuarterDates \n" +
			                "WHERE quarter = '" + quarter + "' \n" +
							"AND year = '" + Integer.parseInt(year) + "'"
			        	);
						rs2.next();
						String start_date = rs2.getString("start_date");
						String end_date = rs2.getString("end_date");
						%>
						<td><%= start_date %></td>
						<td><%= end_date %></td>
						<td><input value="" name="daysOfWeek"></td>
						<td><input value="" name="meetingType"></td>
						<td><input value="" name="attendanceType"></td>
                       	<input type="hidden" name="courseName" value="<%= cn %>">
						<input type="hidden" name="classTitle" value="<%= title %>">
						<input type="hidden" name="classYear" value="<%= year %>">
						<input type="hidden" name="classQuarter" value="<%= quarter %>">
						<input type="hidden" name="sectionID" value="<%= section %>">
						<td><input type="submit" value="Insert"></td>
					</form>
				</tr>
					

				<!-- Iteration stuff? -->
				<%
				rs = stmt.executeQuery(
			    	"SELECT * FROM WeeklyMeetings WHERE s_sectionID = '" + section + "'"
		        );
				%>
				
				<%
				while (rs.next()) {
				%>
				<tr>
					<form action="SectionWeeklyMeetings.jsp" method="get">
						<input type="hidden" value="update" name="action">
						<td><input value="<%= rs.getString("location") %>" name="location"></td>
						<td><input value="<%= rs.getString("time") %>" name="time"></td>
						<td><input value="<%= rs.getString("startTime") %>" name="startTime"></td>
						<td><input value="<%= rs.getString("endTime") %>" name="endTime"></td>
						<td><%= start_date %></td>
						<td><%= end_date %></td>
						<td><input value="<%= rs.getString("daysOfWeek") %>" name="daysOfWeek"></td>
						<td><input value="<%= rs.getString("meetingType") %>" name="meetingType"></td>
						<td><input value="<%= rs.getString("attendanceType") %>" name="attendanceType"></td>
						<input type="hidden" value="<%= section %>" name="s_sectionID">
						<input type="hidden" name="courseName" value="<%= cn %>">
						<input type="hidden" name="classTitle" value="<%= title %>">
						<input type="hidden" name="classYear" value="<%= year %>">
						<input type="hidden" name="classQuarter" value="<%= quarter %>">
						<input type="hidden" name="sectionID" value="<%= section %>">
						<td><input type="submit" value="Update"></td>
					</form>
					<form action="SectionWeeklyMeetings.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= section %>" name="s_sectionID">
						<input type="hidden" value="<%= rs.getString("location") %>" name="location">
						<input type="hidden" value="<%= rs.getString("time") %>" name="time">
						<input type="hidden" value="<%= rs.getString("daysOfWeek") %>" name="daysOfWeek">
						<input type="hidden" name="courseName" value="<%= cn %>">
						<input type="hidden" name="classTitle" value="<%= title %>">
						<input type="hidden" name="classYear" value="<%= year %>">
						<input type="hidden" name="classQuarter" value="<%= quarter %>">
						<input type="hidden" name="sectionID" value="<%= section %>">
						<td><input type="submit" value="Delete"></td>
					</form>
				</tr>
				<%
				}
				
				rs2.close();
				
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
			
			<p></p>
			<br>
			<a href="./SectionsForClass.jsp?courseName=<%= cn %>&classTitle=<%= title %>&classYear=<%= year %>&classQuarter=<%= quarter %>">Back</a>
			<br>
			<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>