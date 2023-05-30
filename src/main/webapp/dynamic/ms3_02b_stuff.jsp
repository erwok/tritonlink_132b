<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String sectionID = request.getParameter("sectionID");
String startDate = request.getParameter("start");
String endDate = request.getParameter("end");
%>
<title>Available Review Session Times for Section <%= sectionID %></title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*, java.util.*" %>
<%@ page import="java.util.Calendar, java.util.Date, java.text.SimpleDateFormat" %>
<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter, java.time.DayOfWeek" %>


<h2>Available Review Session Times for Section <%= sectionID %></h2>

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
	String get_all_sections_in_students_schedules =
    "SELECT DISTINCT s_sectionID \n" +
	"FROM take \n" +
    "WHERE st_id IN \n" +
	"    (SELECT DISTINCT t.st_id AS st_id \n" +
	"     FROM take t, weeklymeetings m \n" +
	"     WHERE t.s_sectionID = m.s_sectionID)";
	rs = stmt.executeQuery(get_all_sections_in_students_schedules);
	List<String> sections = new ArrayList<>();
	while (rs.next()) {
	    sections.add(rs.getString("s_sectionID"));
	}
	
	String get_meetings = null;
	// map of day of week to list of time ranges that are occupied
	Map<String, List<Integer[]>> occupiedTimes = new HashMap<>();
	for (String sid : sections) {
	    get_meetings = 
	        "SELECT starttime, endtime, daysofweek \n" +
		    "FROM weeklymeetings \n" +
	        "WHERE s_sectionID = '" + sid + "'";
	    rs = stmt.executeQuery(get_meetings);
	    
	    while (rs.next()) {
	        String startTime = rs.getString("starttime");
	        String endTime = rs.getString("endtime");
	        String[] days = rs.getString("daysofweek").split(",");
	        // for each day, add to to the periods for that day in the map
	        for (String day : days) {
	            List<Integer[]> periods = occupiedTimes.getOrDefault(day, new ArrayList<>());
	            Integer[] period = new Integer[2];
	            
	            /******************** BEGIN TIME PARSING CODE ********************/
	            String[] parts;
                String ampm;
                int hours, minutes;
                            
                parts = startTime.split(":");
                hours = Integer.parseInt(parts[0]);
                minutes = Integer.parseInt(parts[1].substring(0, 2));
                ampm = parts[1].substring(2);
                if (ampm.equalsIgnoreCase("pm") && hours != 12) {
                    hours += 12;
                } else if (ampm.equalsIgnoreCase("am") && hours == 12) {
                    hours = 0;
                }
                period[0] = (hours * 60) + minutes;
	            
                parts = endTime.split(":");
                hours = Integer.parseInt(parts[0]);
                minutes = Integer.parseInt(parts[1].substring(0, 2));
                ampm = parts[1].substring(2);
                if (ampm.equalsIgnoreCase("pm") && hours != 12) {
                    hours += 12;
                } else if (ampm.equalsIgnoreCase("am") && hours == 12) {
                    hours = 0;
                }
                period[1] = (hours * 60) + minutes;
                /********************* END TIME PARSING CODE *********************/
                
                // add the period and update the periods list in occupiedTimes
                periods.add(period);
                occupiedTimes.put(day, periods);
	        }
	    }
	}
	
	// map of day of week to list of time ranges that are occupied condensed!
	Map<String, List<Integer[]>> condensedOccupiedTimes = new HashMap<>();
	// condense all periods for each day
	for (Map.Entry<String, List<Integer[]>> occupiedDayEntry : occupiedTimes.entrySet()) {
        String day = occupiedDayEntry.getKey();
        List<Integer[]> periods = occupiedDayEntry.getValue();
        
        Integer[][] ps = new Integer[periods.size()][];
        for (int i = 0; i < periods.size(); i++) {
            ps[i] = periods.get(i);
        }
        
        /******************** BEGIN PERIOD CONDENDSING CODE ********************/
        Stack<Integer[]> stack = new Stack<>();
        
     	// sort periods in ascending start time order
        Arrays.sort(ps, new Comparator<Integer[]>(){
            public int compare(Integer[] i1, Integer[] i2)
            {
                return i1[0] - i2[0];
            }
        });
     	
     	// push the first period onto the stack
     	stack.push(ps[0]);
     	
     	// continue and merge when needed
        for (int i = 1; i < ps.length; i++) {
            // get latest interval
            Integer[] top = stack.peek();
   
            // if no overlap with top of stack
            if (top[1] < ps[i][0]) {
                stack.push(ps[i]);
            }
   
            // Otherwise update the ending time of top if ending of current
            // interval is more
            else if (top[1] < ps[i][1]) {
                top[1] = ps[i][1];
                stack.pop();
                stack.push(top);
            }
        }
     	
     	List<Integer[]> condensedPeriods = new ArrayList<>();
     	while (!stack.isEmpty()) {
     	    // add to the front to maintain ascending order for the periods
     	    condensedPeriods.add(0, stack.pop());
     	}
     	/******************** END PERIOD CONDENDSING CODE ********************/
     	
     	condensedOccupiedTimes.put(day, condensedPeriods);
	}
	%>
	
	
	<%
	/******************** BEGIN FINDING AVAILABLE PERIODS CODE ********************/
	
	// 8am to 8pm is 480 to 1200
	
	int startTimeRange = 480;  // 8:00 AM
	int endTimeRange = 1200;  // 8:00 PM
	
	// map of day of week to list of time ranges that are available
	Map<String, List<Integer[]>> availableTimes = new HashMap<>();
	
	// Iterate over each day and its occupied periods
	for (Map.Entry<String, List<Integer[]>> entry : condensedOccupiedTimes.entrySet()) {
	    String day = entry.getKey();
	    List<Integer[]> occupiedPeriods = entry.getValue();
	    
	    List<Integer[]> availablePeriods = new ArrayList<>();
	    
	    if (occupiedPeriods.isEmpty()) {
	        // If there are no occupied periods for the day, the entire range is available
	        Integer[] period = {startTimeRange, endTimeRange};
	        availablePeriods.add(period);
	    }
	    else {
	        // Check the available periods between occupied periods
	        Integer[] firstPeriod = occupiedPeriods.get(0);
	        if (firstPeriod[0] > startTimeRange) {
	            // If the first occupied period starts after the start time range, add an available period
	            Integer[] period = {startTimeRange, firstPeriod[0]};
	            availablePeriods.add(period);
	        }
	        
	        for (int i = 1; i < occupiedPeriods.size(); i++) {
	            Integer[] previousPeriod = occupiedPeriods.get(i - 1);
	            Integer[] currentPeriod = occupiedPeriods.get(i);
	            
	            if (previousPeriod[1] < currentPeriod[0]) {
	                // If there is a gap between the previous period and the current period, add an available period
	                Integer[] period = {previousPeriod[1], currentPeriod[0]};
	                availablePeriods.add(period);
	            }
	        }
	        
	        Integer[] lastPeriod = occupiedPeriods.get(occupiedPeriods.size() - 1);
	        if (lastPeriod[1] < endTimeRange) {
	            // If the last occupied period ends before the end time range, add an available period
	            Integer[] period = {lastPeriod[1], endTimeRange};
	            availablePeriods.add(period);
	        }
	    }
	    
	    availableTimes.put(day, availablePeriods);
	    /******************** END FINDING AVAILABLE PERIODS CODE ********************/
	}
	%>
	
	<%
	/******************** BEGIN EXPANDING AVAILABLE PERIODS CODE ********************/

	// map of day of week to list of 1-hour intervals that are available
	Map<String, List<Integer[]>> expandedAvailableTimes = new HashMap<>();
	
	// Iterate over each day and its available periods
	for (Map.Entry<String, List<Integer[]>> entry : availableTimes.entrySet()) {
	    String day = entry.getKey();
	    List<Integer[]> availablePeriods = entry.getValue();
	    
	    List<Integer[]> expandedPeriods = new ArrayList<>();
	    
	    for (Integer[] period : availablePeriods) {
	        // round up for the start of the hour and down to the end of the hour for the periods
	        int startHour = ((period[0] + 59) / 60) * 60;
	        int endHour = (period[1] / 60) * 60;
	        
	        
	        // Generate 1-hour intervals within the available period
	        for (int hour = startHour; hour < endHour; hour += 60) {
	            Integer[] expandedPeriod = {hour, hour + 60};  // 1-hour interval
	            expandedPeriods.add(expandedPeriod);
	        }
	    }
	    
	    expandedAvailableTimes.put(day, expandedPeriods);
	}

	
	/******************** END EXPANDING AVAILABLE PERIODS CODE ********************/
	%>
	
	<%
	/* 
	Find num of each weekday between input start and end dates
	*/
	DateTimeFormatter dtf = DateTimeFormatter.ofPattern("M/d/yyyy");
    LocalDate start = LocalDate.parse(startDate, dtf);
    LocalDate end = LocalDate.parse(endDate, dtf);
    
    // used later
    long daysBetween = end.toEpochDay() - start.toEpochDay();
	%>
	
	<table>
	<%
	/******************** DISPLAYING EXPANDED AVAILABLE TIMES CODE ********************/
	for (int i = 0; i <= daysBetween; i++) {
	    LocalDate currDate = start.plusDays(i);
	    String dayOfWeek = currDate.getDayOfWeek().name();
	    dayOfWeek = dayOfWeek.substring(0, 1) + dayOfWeek.substring(1).toLowerCase();
	    String month = currDate.getMonth().toString();
	    int day = currDate.getDayOfMonth();
	    
	    List<Integer[]> expandedPeriods = expandedAvailableTimes.get(dayOfWeek);
	    if (expandedPeriods == null) {
	        continue;
	    }
	    for (Integer[] period : expandedPeriods) {
	        int startHour = period[0] / 60;
	        int endHour = period[1] / 60;
	        int startMinute = period[0] % 60;
	        int endMinute = period[1] % 60; 
	        
	        String sampm = "";
	        if (startHour < 12) {
	            sampm = "AM";
	        }
	        else {
	            startHour -= 12;
	            startHour = startHour == 0 ? 12 : startHour;
	            sampm = "PM";
	        }
	        String eampm = "";
	        if (endHour < 12) {
	            eampm = "AM";
	        }
	        else {
	            endHour -= 12;
	            endHour = endHour == 0 ? 12 : endHour;
	            eampm = "PM";
	        }
    %>
    		
    		<tr><td><%= String.format("%s %d %s %02d:%02d %s", month, day, dayOfWeek, startHour, startMinute, sampm) %> - <%= String.format("%02d:%02d %s", endHour, endMinute, eampm) %></td></tr>
    
	<%        
	    }
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
	<a href="./ms3_02b_select_period.jsp">Back to period selection page</a>
	<br>
	<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>