<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String[] fc_name = request.getParameter("fc_name").split(",");
String s_sectionid = fc_name[1];
int startMonth = Integer.parseInt(request.getParameter("startMonth"));
int startDate = Integer.parseInt(request.getParameter("startDate"));
int endMonth = Integer.parseInt(request.getParameter("endMonth"));
int endDate = Integer.parseInt(request.getParameter("endDate"));
%>
<title>Professor <%= fc_name[0] %> 's <%= s_sectionid %> Review Scheduling Help</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*, java.util.*" %>
<%@ page import="java.time.*, java.time.format.DateTimeFormatter" %>


<h2><%= fc_name[0] %>'s <%= s_sectionid %> Review Scheduling Help</h2>

	<%
	try {
	    // Load driver
	    DriverManager.registerDriver(new org.postgresql.Driver());
	    
	    // Make a connection to the Oracle datasource
	    Connection connection = DriverManager.getConnection
		("jdbc:postgresql:tritonlink?user=postgres&password=helloworld");
	%>
	
	<%
		Statement stmt = connection.createStatement();
	%>
	
	<h4>Available Review Session for Current classes, <%= s_sectionid %></h4>
	<table style="border-collapse: collapse;">
	<tr style="border-bottom: 1px solid black;">
		<th style="border: 1px solid black; padding: 5px;">Month</th>
		<th style="border: 1px solid black; padding: 5px;">Date</th>
		<th style="border: 1px solid black; padding: 5px;">Day of week</th>
		<th style="border: 1px solid black; padding: 5px;">Start Time</th>
		<th style="border: 1px solid black; padding: 5px;">End Time</th>
	</tr>

	<%
	// Get start date and end date to make LocalDate objects
	LocalDate startCalendar = LocalDate.of(2018, startMonth, startDate);
	LocalDate endCalendar = LocalDate.of(2018, endMonth, endDate);

	// Clear the AvailableReviewSession table
	String clear_AvailableReviewSession = "DELETE FROM AvailableReviewSession";
	stmt.executeUpdate(clear_AvailableReviewSession);

	// Iterate through the dates and insert into AvailableReviewSession
	for (LocalDate tmpDate = startCalendar; !tmpDate.isAfter(endCalendar); tmpDate = tmpDate.plusDays(1)) {
		if(tmpDate.getDayOfWeek().getValue() <= 5) {
		// 1:Mon 2:Tue 3:Wed 4:Thu 5:Fri 6:Sat 7:Sun
			// insert into AvailableReviewSession
			for(int i = 0; i < 12; i++) {
				String insert_into_AvailableReviewSession = "INSERT INTO AvailableReviewSession VALUES (?,?,?,?,?)";
				PreparedStatement pstmt = connection.prepareStatement(insert_into_AvailableReviewSession);
				pstmt.setInt(1, tmpDate.getMonthValue());
				pstmt.setInt(2, tmpDate.getDayOfMonth());
				pstmt.setString(3, tmpDate.getDayOfWeek().toString());
				pstmt.setTime(4, Time.valueOf(LocalTime.of(8 + i, 0)));
				pstmt.setTime(5, Time.valueOf(LocalTime.of(9 + i, 0)));
				pstmt.executeUpdate();
			}
		}
	}

	// Exclude the AvailableReviewSession depends on the all of Taker's schedule
	// Get the Taker for the session
	String GET_section_roster_QUERY = 
		"SELECT s.st_id \n" +
		"FROM student s, take t \n" + 
		"WHERE t.s_sectionID = '" + s_sectionid + "' AND s.st_id = t.st_id ";
	
	ResultSet rs_taker = stmt.executeQuery(GET_section_roster_QUERY);

	// Iterate through the Taker's schedule and exclude the AvailableReviewSession
	while(rs_taker.next()){
		String st_id = rs_taker.getString("st_id");

		// Get the Taker's section schedule
		String GET_Taker_schedule_QUERY = 
			"SELECT w.* FROM take t, weeklymeetings w \n" + 
			"WHERE t.st_id = '" + st_id + "' AND \n" +
			"t.s_sectionID = w.s_sectionID";
		
		ResultSet rs_weeklyMeeting = stmt.executeQuery(GET_Taker_schedule_QUERY);

		// Iterate through the Taker's schedule and exclude the AvailableReviewSession
		while(rs_weeklyMeeting.next()){
			String daysOfWeek = rs_weeklyMeeting.getString("daysOfWeek");
			LocalTime startTimeWM = LocalTime.parse(rs_weeklyMeeting.getString("startTime"));
			LocalTime endTimeWM = LocalTime.parse(rs_weeklyMeeting.getString("endTime"));

			// Iterate through the AvailableReviewSession and exclude the AvailableReviewSession
			String delete_AvailableReviewSession_QUERY = 
				"DELETE FROM AvailableReviewSession \n" +
				"WHERE daysOfWeek = '" + daysOfWeek + "' AND \n" +
				"startTime <= '" + endTimeWM + "' AND \n" +
				"endTime > '" + startTimeWM + "'";
		}

		rs_weeklyMeeting.close();
	}

	rs_taker.close();

	ResultSet rs = null;
	String get_AvailableReviewSession = "SELECT * FROM AvailableReviewSession";
	rs = stmt.executeQuery(get_AvailableReviewSession);
	while (rs.next()) {
		String month = rs.getString("month");
		String date = rs.getString("date");
		String dayOfWeek = rs.getString("dayOfWeek");		
		LocalTime startTime = rs.getTime("startTime").toLocalTime();
		String startTimeString = startTime.format(DateTimeFormatter.ofPattern("HH:mm"));
		LocalTime endTime = rs.getTime("endTime").toLocalTime();
		String endTimeString = endTime.format(DateTimeFormatter.ofPattern("HH:mm"));
	%>
		<tr style="border-bottom: 1px solid black;">
			<td style="border: 1px solid black; padding: 5px;"><%= month %></td>
			<td style="border: 1px solid black; padding: 5px;"><%= date %></td>
			<td style="border: 1px solid black; padding: 5px;"><%= dayOfWeek %></td>
			<td style="border: 1px solid black; padding: 5px;"><%= startTimeString %></td>
			<td style="border: 1px solid black; padding: 5px;"><%= endTimeString %></td>
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
	
	
	<br>
	<a href="./ms3_02b_ProfSelectionReviewSchedulingHelp.jsp">Back to Professor selection page</a>
	<br>
	<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>

<!--	
	CREATE TABLE AvailableReviewSession (
		month INT,
		date INT,
		dayOfWeek VARCHAR(20),
		startTime TIME,
		endTime TIME,
		PRIMARY KEY (month, date, dayOfWeek, startTime, endTime)
	); 
 -->