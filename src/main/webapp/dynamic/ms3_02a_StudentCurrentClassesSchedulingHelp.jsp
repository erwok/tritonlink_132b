<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String studentID = request.getParameter("st_id").split(",")[0];
String fullName = request.getParameter("st_id").split(",")[1];
%>
<title>Student <%= studentID %>'s Current Class Scheduling Help</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*, java.util.*" %>
<%@ page import="java.time.LocalTime, java.time.format.DateTimeFormatter" %>


<h2><%= fullName %>'s Current Classes Scheduling Help</h2>

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
		ResultSet rs = null;
	%>
	
	
	<%
		// Get current classes offered (Spring 2018)
		String GET_current_classes_QUERY = 
	        "SELECT * FROM Section \n" + 
			"WHERE classyear = 2018 AND classquarter = 'SPRING'";
		rs = stmt.executeQuery(GET_current_classes_QUERY);
		
		List<String[]> offeredClasses = new ArrayList<>();
		while (rs.next()) {
		    String[] sec = new String[3];
		    sec[0] = rs.getString("coursenumber");
		    sec[1] = rs.getString("classtitle");
		    sec[2] = rs.getString("s_sectionid");
		    offeredClasses.add(sec);
		}
		
		// Get student's current schedule
		String get_current_schedule = "SELECT * FROM take WHERE st_id = '" + studentID + "'";
		rs = stmt.executeQuery(get_current_schedule);
		
		List<String[]> schedule = new ArrayList<>();
		while (rs.next()) {
		    String[] sec = new String[3];
		    sec[0] = rs.getString("cr_courseNumber");
		    sec[1] = rs.getString("cl_title");
		    sec[2] = rs.getString("s_sectionid");
		}
		
		// Get weekly meetings associated with each section, their days of the week and their times
		// Also save quarter start date and quarter end date for SPRING 2018
		
		// Get START_DATE and END_DATE for SPRING 2018
		String get_current_dates = 
			"SELECT * FROM quarterdates WHERE quarter = 'SPRING' AND year = 2018";
        rs = stmt.executeQuery(get_current_dates);
        rs.next();
        String start_date = rs.getString("start_date");
        String end_date = rs.getString("end_date");
        
        /* ADD COLUMNS FOR courseNumber, title, quarter, year, and CONSTRAINTS for each of those */
        // Might do that in the future, right now use s_sectionID to uniquely identify classes
        
        // Get student's occupied times
        // class section to dates and days and times for that section
        Map<String, Map<String, List<String>>> s_dat = new HashMap<>();
        // for each class in the student's schedule, find all weekly meetings for that 
        // class and for each day for each weekly meeting, add a new time to the list
        // associated with the times for that day
        for (String[] sec : schedule) {
         	// days and times
            Map<String, List<String>> dat = new HashMap<>();
            // sec[2] contains the s_sectionID
          	s_dat.put(sec[2], dat);
            String get_days_times = 
            "SELECT * FROM weeklymeetings WHERE s_sectionID = '" + sec[2] + "'";
            rs = stmt.executeQuery(get_days_times);
            while (rs.next()) {
                String[] days = rs.getString("daysOfWeek").split(",");
                for (String d : days) {
                    if (!dat.containsKey(d)) {
                        List<String> times = new ArrayList<>();
                        dat.put(d, times);
                    }
                    List<String> times = dat.get(d);
                    // time example: "6:30pm,7:30pm"
                    times.add(rs.getString("starttime") + "," + rs.getString("endtime"));
                }
            }
        }
        
        
        List<String[]> notTakingClasses = new ArrayList<>();
	    // Compare the offeredClasses and schedule lists to find classes the student is not taking
	    for (String[] offeredClass : offeredClasses) {
        	boolean isTakingClass = false;
	    	for (String[] scheduledClass : schedule) {
            	if (offeredClass[0].equals(scheduledClass[0]) && offeredClass[1].equals(scheduledClass[1]) && offeredClass[2].equals(scheduledClass[2])) {
                	isTakingClass = true;
                	break;
             	}
         	}
         	if (!isTakingClass) {
            	notTakingClasses.add(offeredClass);
         	}
     	}
	    
	 	// Get occupied times of classes not taken by the student
        // class section to dates and days and times for that section
        Map<String, Map<String, List<String>>> s_not_dat = new HashMap<>();
        // for each class in the student's schedule, find all weekly meetings for that 
        // class and for each day for each weekly meeting, add a new time to the list
        // associated with the times for that day
        for (String[] sec : notTakingClasses) {
         	// days and times
            Map<String, List<String>> dat = new HashMap<>();
            // sec[2] contains the s_sectionID
          	s_not_dat.put(sec[2], dat);
            String get_days_times = 
            "SELECT * FROM weeklymeetings WHERE s_sectionID = '" + sec[2] + "'";
            rs = stmt.executeQuery(get_days_times);
            while (rs.next()) {
                String[] days = rs.getString("daysOfWeek").split(",");
                for (String d : days) {
                    if (!dat.containsKey(d)) {
                        List<String> times = new ArrayList<>();
                        dat.put(d, times);
                    }
                    List<String> times = dat.get(d);
                    // time example: "6:30pm,7:30pm"
                    times.add(rs.getString("starttime") + "," + rs.getString("endtime"));
                }
            }
        }
        
        
        List<String[]> overlappingSections = new ArrayList<>();
		// Iterate over the entries in s_dat (student's occupied times)
		for (Map.Entry<String, Map<String, List<String>>> occupiedEntry : s_dat.entrySet()) {
		    String sectionID = occupiedEntry.getKey();
		    Map<String, List<String>> occupiedTimes = occupiedEntry.getValue();
		
		    // Check if the section has corresponding occupied times in s_not_dat (classes not taken by the student)
		    if (s_not_dat.containsKey(sectionID)) {
		        Map<String, List<String>> notTakenTimes = s_not_dat.get(sectionID);
		
		        // Iterate over the days of the week
		        for (Map.Entry<String, List<String>> occupiedDayEntry : occupiedTimes.entrySet()) {
		            String occupiedDay = occupiedDayEntry.getKey();
		            List<String> occupiedTimeSlots = occupiedDayEntry.getValue();
		
		            // Check if the day exists in notTakenTimes
		            if (notTakenTimes.containsKey(occupiedDay)) {
		                List<String> notTakenTimeSlots = notTakenTimes.get(occupiedDay);
		
		                // Iterate over the occupied time slots
		                for (String occupiedTimeSlot : occupiedTimeSlots) {
		                    String[] occupiedTimesplit = occupiedTimeSlot.split(",");
		                    String occupiedStartTime = occupiedTimesplit[0];
		                    String occupiedEndTime = occupiedTimesplit[1];
		
		                    // Iterate over the not taken time slots
		                    for (String notTakenTimeSlot : notTakenTimeSlots) {
		                        String[] notTakenTimesplit = notTakenTimeSlot.split(",");
		                        String notTakenStartTime = notTakenTimesplit[0];
		                        String notTakenEndTime = notTakenTimesplit[1];
		                 
		                        
		                        // Code to figure out if the times are overlapping
		                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("h:mma");
		                        LocalTime start1 = LocalTime.parse(occupiedStartTime.toLowerCase(), formatter);
	                            LocalTime end1 = LocalTime.parse(occupiedEndTime.toLowerCase(), formatter);
	                            LocalTime start2 = LocalTime.parse(notTakenStartTime.toLowerCase(), formatter);
	                            LocalTime end2 = LocalTime.parse(notTakenEndTime.toLowerCase(), formatter);
		
		                        // Compare the start and end times for overlap
		                        if (!(end1.isBefore(start2) || start1.isAfter(end2))) {
		                        // if (isTimeOverlap(occupiedStartTime, occupiedEndTime, notTakenStartTime, notTakenEndTime)) {
		                            // Overlapping time slots found, add the section to the list of overlappingSections
		                            String[] overlappingSection = new String[3];
		                            overlappingSection[0] = sectionID;
		                            overlappingSection[1] = occupiedDay;
		                            overlappingSection[2] = occupiedStartTime + "-" + occupiedEndTime;
		                            overlappingSections.add(overlappingSection);
		                            break; // No need to check further for this occupied time slot
		                        }
		                    }
		                }
		            }
		        }
		    }
		}
		    
		// Now we have a list of overlapping sections

	%>
	
	
	<%-- <table style="border-collapse: collapse;">
	    <tr style="border-bottom: 1px solid black;">
	        <th style="border: 1px solid black; padding: 5px;">Course Number</th>
	        <th style="border: 1px solid black; padding: 5px;">Title</th>
	        <th style="border: 1px solid black; padding: 5px;">Quarter</th>
	        <th style="border: 1px solid black; padding: 5px;">Year</th>
	        <th style="border: 1px solid black; padding: 5px;">Section</th>
	        <th style="border: 1px solid black; padding: 5px;">Grading Option</th>
	        <th style="border: 1px solid black; padding: 5px;">Units Option</th>
	    </tr>
	    <% 
	    String getTake = "SELECT * FROM take WHERE st_id = '" + studentID + "';";
		rs = stmt.executeQuery(getTake);
	    
	    while (rs.next()) { 
	    %>
	        <tr style="border-bottom: 1px solid black;">
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("cr_courseNumber") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("cl_title") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("cl_quarter") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getInt("cl_year") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("s_sectionID") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("take_gradingOption") %></td>
	            <td style="border: 1px solid black; padding: 5px;"><%= rs.getString("take_units") %></td>
	        </tr>
	    <% } %>
	</table> --%>
	
	
	
	
	<%-- <%
	rs.close();
	%> --%>

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
	<a href="./ms3_02a_StudentSelectionClassSchedulingHelp.jsp">Back to student selection page</a>
	<br>
	<a href="./00_index.jsp">Back to Home Page</a>
	
	<%
	/* 		 // Function to check if two time slots overlap
	private boolean isTimeOverlap(String startTime1, String endTime1, String startTime2, String endTime2) {
	    // Implement your logic to compare the start and end times for overlap
	    // Convert the time strings to appropriate format (e.g., using SimpleDateFormat) for comparison
	    // Compare the times and return true if there is an overlap, false otherwise
	    // You can use Java's Date/Time API or external libraries for time comparison if needed
	
	    // Example implementation assuming startTime and endTime are in "hh:mma" format (e.g., "6:30pm")
	    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("h:mma");
	
	    LocalTime start1 = LocalTime.parse(startTime1.toLowerCase(), formatter);
	    LocalTime end1 = LocalTime.parse(endTime1.toLowerCase(), formatter);
	    LocalTime start2 = LocalTime.parse(startTime2.toLowerCase(), formatter);
	    LocalTime end2 = LocalTime.parse(endTime2.toLowerCase(), formatter);
	
	    // Check for overlap
	    return !(end1.isBefore(start2) || start1.isAfter(end2));
	} */
	
	
	%>

</body>
</html>