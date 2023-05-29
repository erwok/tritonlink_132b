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
		    schedule.add(sec);
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

		// Iterate over the entries in s_not_dat (classes not taken by the student)
		for (Map.Entry<String, Map<String, List<String>>> notTakenEntry : s_not_dat.entrySet()) {
		    String notTakenSectionID = notTakenEntry.getKey();
		    Map<String, List<String>> notTakenTimes = notTakenEntry.getValue();

		    // Iterate over the entries in s_dat (student's occupied times)
		    for (Map.Entry<String, Map<String, List<String>>> occupiedEntry : s_dat.entrySet()) {
		        String occupiedSectionID = occupiedEntry.getKey();
		        Map<String, List<String>> occupiedTimes = occupiedEntry.getValue();

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
		                        
		                        String[] parts;
		                        String ampm;
		                        int hours, minutes;
		                                    
		                        parts = occupiedStartTime.split(":");
		                        hours = Integer.parseInt(parts[0]);
		                        minutes = Integer.parseInt(parts[1].substring(0, 2));
		                        ampm = parts[1].substring(2);
		                        if (ampm.equalsIgnoreCase("pm") && hours != 12) {
		                            hours += 12;
		                        } else if (ampm.equalsIgnoreCase("am") && hours == 12) {
		                            hours = 0;
		                        }
		                        int start1 = (hours * 60) + minutes;
		                        
		                        parts = occupiedEndTime.split(":");
		                        hours = Integer.parseInt(parts[0]);
		                        minutes = Integer.parseInt(parts[1].substring(0, 2));
		                        ampm = parts[1].substring(2);
		                        if (ampm.equalsIgnoreCase("pm") && hours != 12) {
		                            hours += 12;
		                        } else if (ampm.equalsIgnoreCase("am") && hours == 12) {
		                            hours = 0;
		                        }
		                        int end1 = (hours * 60) + minutes;
		                        
		                        parts = notTakenStartTime.split(":");
		                        hours = Integer.parseInt(parts[0]);
		                        minutes = Integer.parseInt(parts[1].substring(0, 2));
		                        ampm = parts[1].substring(2);
		                        if (ampm.equalsIgnoreCase("pm") && hours != 12) {
		                            hours += 12;
		                        } else if (ampm.equalsIgnoreCase("am") && hours == 12) {
		                            hours = 0;
		                        }
		                        int start2 = (hours * 60) + minutes;
		                        
		                        parts = notTakenEndTime.split(":");
		                        hours = Integer.parseInt(parts[0]);
		                        minutes = Integer.parseInt(parts[1].substring(0, 2));
		                        ampm = parts[1].substring(2);
		                        if (ampm.equalsIgnoreCase("pm") && hours != 12) {
		                            hours += 12;
		                        } else if (ampm.equalsIgnoreCase("am") && hours == 12) {
		                            hours = 0;
		                        }
		                        int end2 = (hours * 60) + minutes;
		                        
		                    	// Compare the start and end times for overlap
		                    	if (!(end1 < start2) || start1 > end2) {
		                            // Overlapping time slots found, add the sections to the list of overlappingSections
		                            String[] overlappingSection = new String[4];
		                            overlappingSection[0] = occupiedSectionID;
		                            overlappingSection[1] = notTakenSectionID;
		                            overlappingSection[2] = occupiedDay;
		                            overlappingSection[3] = occupiedStartTime + "-" + occupiedEndTime;
		                            overlappingSections.add(overlappingSection);
		                            break; // No need to check further for this occupied time slot
		                        }
		                    }
		                }
		            }
		        }
		    }
		}
		
		Set<String> uniqueOverlappingSections = new HashSet<>();
        for (String[] sec : overlappingSections) {
    	    String s = sec[1]; // not taken class
    	    uniqueOverlappingSections.add(s);
        }
		
		// Now we have a list of overlapping sections
	%>
	
	<h4>Current classes with conflicting weekly meeting(s)</h4>
	<table style="border-collapse: collapse;">
    <tr style="border-bottom: 1px solid black;">
        <th style="border: 1px solid black; padding: 5px;">Course Number</th>
        <th style="border: 1px solid black; padding: 5px;">Title</th>
        <th style="border: 1px solid black; padding: 5px;">Section</th>
    </tr>
    
	<%
	for (String notTakingSecID : uniqueOverlappingSections) {
		
		String get_class_key = "SELECT * FROM Section WHERE s_sectionID = '" + notTakingSecID + "'";
		rs = stmt.executeQuery(get_class_key);
		rs.next();
		
		String num = rs.getString("coursenumber");
		String title = rs.getString("classtitle");
	%>
        <tr style="border-bottom: 1px solid black;">
            <td style="border: 1px solid black; padding: 5px;"><%= num %></td>
            <td style="border: 1px solid black; padding: 5px;"><%= title %></td>
            <td style="border: 1px solid black; padding: 5px;"><%= notTakingSecID %></td>
        </tr>
	<%
	}
	%>
	
	</table>
	
	
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
	<a href="./ms3_02a_StudentSelectionClassSchedulingHelp.jsp">Back to student selection page</a>
	<br>
	<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>