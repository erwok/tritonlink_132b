<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String studentID = request.getParameter("st_id").split(",")[0];
String fullName = request.getParameter("st_id").split(",")[1];
String majorCode = request.getParameter("majorcode");
%>
<title><%= fullName %>'s Remaining Requirements for <%= majorCode %></title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*, java.util.*" %>

<h2><%= fullName %>'s Remaining Requirements for <%= majorCode %></h2>


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
	
		String query_degree_concentrations = "SELECT * FROM DegreeConcentrations WHERE majorcode = '" + majorCode + "'";
		ResultSet rs = stmt.executeQuery(query_degree_concentrations);
		
		// list of concentrations under the selected degree
		List<String> concentrations = new ArrayList<>();
		while (rs.next()) {
		    concentrations.add(rs.getString("concentrationName"));
		}
		
		// concentrations and lists of their courses
		Map<String, List<String>> concentrationCourses = new HashMap<>();
		String query_concentration_courses = null;
		for (String c : concentrations) {
		    query_concentration_courses = "SELECT * FROM ConcentrationCourses WHERE name = '" + c + "'";
		    rs = stmt.executeQuery(query_concentration_courses);
		    
		    List<String> courses = null;
		    while (rs.next()) {
		        if (concentrationCourses.get(c) == null) {
		            List<String> l = new ArrayList<>();
		            concentrationCourses.put(c, l);
		        }
		        courses = concentrationCourses.get(c);
		        courses.add(rs.getString("cr_courseNumber"));
		    }
		}
		
		/*
		
		TODO: 
		    NEED TO TAKE INTO ACCOUNT grading option, grade received, and units the class was taken for
		    
		    IDEA: use multiple hashmaps to store each of those data points
		*/
		
		// concentrations and what courses the masters student has completed under them
		Map<String, List<String>> conTakenMap = new HashMap<>();
		// concentrations and grades achieved in completed courses
		Map<String, List<String>> conGradeMap = new HashMap<>();
		// concentrations and units taken in completed courses
		Map<String, List<Integer>> conUnitsMap = new HashMap<>();
		Map<String, Integer> conTotalUnitsMap = new HashMap<>();
		// concentrations and their min_units requirement
		Map<String, Integer> conMinUnitsMap = new HashMap<>();
		// concentrations and their min_gpa requirement
		Map<String, Double> conMinGpaMap = new HashMap<>();
		String query_completed_courses = null;
		for (String c : concentrations) {
		    query_completed_courses = 
            "SELECT p.cr_courseNumber AS courseNum, p.pasttake_gradingOption AS gradingOption, \n" +
		    "p.pasttake_units AS units, p.pasttake_grade AS grade, con.min_units AS min_units, con.min_gpa AS min_gpa \n" +
            "FROM ConcentrationCourses c, pasttake p, Concentration con \n" +
		    "WHERE p.st_id = '" + studentID + "' \n" +
            "AND p.cr_courseNumber = c.cr_courseNumber \n" +
		    "AND c.name = '" + c + "' \n" +
		    "AND c.name = con.name";
		    rs = stmt.executeQuery(query_completed_courses);
		    
		    List<String> courses = null;
		    while (rs.next()) {
		        if (!conTakenMap.containsKey(c)) {
		            List<String> l = new ArrayList<>();
		            conTakenMap.put(c, l);
		        }
		        courses = conTakenMap.get(c);
		        courses.add(rs.getString("courseNum"));
		        
		        // only classes taken for a Letter grade get factored for gpa calculation
		        if (rs.getString("gradingOption").equals("Letter")) {
		            if (!conGradeMap.containsKey(c)) {
			            List<String> l = new ArrayList<>();
			            conGradeMap.put(c, l);
			        }
			        List<String> grades = conGradeMap.get(c);
			        grades.add(rs.getString("grade"));
		        }
		        
		        // Courses taken for S/U or letter both get their units recorded
		        if (!conUnitsMap.containsKey(c)) {
		            List<Integer> l = new ArrayList<>();
		            conUnitsMap.put(c, l);
		        }
		        // conUnitsMap.put(c, conUnitsMap.get(c) + Integer.parseInt(rs.getString("units")));
		        List<Integer> units = conUnitsMap.get(c);
		        units.add(Integer.parseInt(rs.getString("units")));
		        
		        // save total units taken for a concentration as well
		        if (!conTotalUnitsMap.containsKey(c)) {
		            conTotalUnitsMap.put(c, 0);
		        }
		        conTotalUnitsMap.put(c, conTotalUnitsMap.get(c) + Integer.parseInt(rs.getString("units")));
		        
		        // record the min requirements for concentrations
		        if (!conMinUnitsMap.containsKey(c)) {
		            conMinUnitsMap.put(c, rs.getInt("min_units"));
		        }
		       	if (!conMinGpaMap.containsKey(c)) {
		       	    conMinGpaMap.put(c, rs.getDouble("min_gpa"));
		       	}
		    }
		}
		
		Map<String, Double> grade_conversion = new HashMap<>();
		grade_conversion.put("A+", 4.3);
		grade_conversion.put("A", 4.0);
		grade_conversion.put("A-", 3.7);
		grade_conversion.put("B+", 3.4);
		grade_conversion.put("B", 3.1);
		grade_conversion.put("B-", 2.8);
		grade_conversion.put("C+", 2.5);
		grade_conversion.put("C", 2.2);
		grade_conversion.put("C-", 1.9);
		grade_conversion.put("D", 1.6);
		
		// concentrations and gpas students earned in them
		Map<String, Double> conGpaMap = new HashMap<>();
		for (Map.Entry<String, List<String>> entry : conGradeMap.entrySet()) {
		    String concentration = entry.getKey();
		    List<String> grades = entry.getValue();
		    List<Integer> units = conUnitsMap.get(concentration);
		    
		    double totalPoints = 0;
		    for (int i = 0; i < grades.size(); i++) {
		        totalPoints += grade_conversion.get(grades.get(i)) * units.get(i);
		    }
		   	
		    double gpa = ((double)(int)(totalPoints * 100 / conTotalUnitsMap.get(concentration))) / 100 ;
			conGpaMap.put(concentration, gpa);
		}
		
		// Obtain the list of concentrations that the selected Master student has achieved for the selected Degree
		List<String[]> completedConcentrations = new ArrayList<>();
        List<String[]> incompleteConcentrations = new ArrayList<>();
        // Obtain the courses from each concentration that the master student has not yet taken
  		Map<String, List<String>> conNotTakenCourses = new HashMap<>();
		for (String c : concentrations) {
		    // if the MS student has taken enough units and has a high enough gpa for 
		    // a concentration, they have completed the concentration
		    if (conTotalUnitsMap.get(c) >= conMinUnitsMap.get(c) && conGpaMap.get(c) >= conMinGpaMap.get(c)) {
		        String[] conInfo = new String[3];
		        conInfo[0] = c;
		        conInfo[1] = "" + conTotalUnitsMap.get(c);
		        conInfo[2] = "" + conGpaMap.get(c);
		        completedConcentrations.add(conInfo);
		    }
		    else {
		        String[] inConInfo = new String[3];
		        inConInfo[0] = c;
		        inConInfo[1] = "" + conTotalUnitsMap.get(c);
		        inConInfo[2] = "" + conGpaMap.get(c);
		        incompleteConcentrations.add(inConInfo);
		    }
		    concentrationCourses.get(c).removeAll(conTakenMap.get(c));
		    conNotTakenCourses.put(c, concentrationCourses.get(c));
		}
		
		// Now, can just use completedConcentrations and conNotTakenCourses to display everything I need!
	%>
	
	<style>
	    .completed-heading {
	        margin-bottom: 5px;
	    }
	
	    .completed-table {
	        margin-top: 0;
	    }
	</style>
	
	<h4 class="completed-heading" style="font-size: 18px; font-weight: bold;">Completed Concentrations</h4>
	<table class="completed-table" style="border-collapse: collapse; width: 20%;">
	    <tr style="background-color: lightgray;">
	        <th style="padding: 8px; border: 1px solid black;">Concentration</th>
	        <th style="padding: 8px; border: 1px solid black;">Completed Units</th>
	        <th style="padding: 8px; border: 1px solid black;">Acquired GPA</th>
	    </tr>
	    <% for (String[] conInfo : completedConcentrations) { %>
	    <tr style="border: 1px solid black;">
	        <td style="padding: 8px; border: 1px solid black;"><%= conInfo[0] %></td>
	        <td style="padding: 8px; border: 1px solid black;"><%= conInfo[1] %></td>
	        <td style="padding: 8px; border: 1px solid black;"><%= conInfo[2] %></td>
	    </tr>
	    <% } %>
	</table>
	<br>
	
	<h4 class="completed-heading" style="font-size: 18px; font-weight: bold;">Incomplete Concentrations</h4>
	<table class="completed-table" style="border-collapse: collapse; width: 20%;">
	    <tr style="background-color: lightgray;">
	        <th style="padding: 8px; border: 1px solid black;">Concentration</th>
	        <th style="padding: 8px; border: 1px solid black;">Completed Units</th>
	        <th style="padding: 8px; border: 1px solid black;">Acquired GPA</th>
	    </tr>
	    <% for (String[] inConInfo : incompleteConcentrations) { %>
	    <tr style="border: 1px solid black;">
	        <td style="padding: 8px; border: 1px solid black;"><%= inConInfo[0] %></td>
	        <td style="padding: 8px; border: 1px solid black;"><%= inConInfo[1] %></td>
	        <td style="padding: 8px; border: 1px solid black;"><%= inConInfo[2] %></td>
	    </tr>
	    <% } %>
	</table>
	<br>
	
	
	<style>
	    .not-taken-heading {
	        margin-bottom: 5px;
	    }
	
	    .not-taken-table {
	        margin-top: 0;
	    }
	</style>
	
	<%
	for (Map.Entry<String, List<String>> entry : conNotTakenCourses.entrySet()) {
	    String concentration = entry.getKey();
	    List<String> notTakenCourses = entry.getValue();
	%>
	    <h4 class="not-taken-heading" style="font-size: 18px; font-weight: bold;">Courses not taken yet for concentration <u><%= concentration %></u></h4>
	    <table class="not-taken-table" style="border-collapse: collapse; width: 20%;">
	        <tr style="background-color: lightgray;">
	            <th style="padding: 8px; border: 1px solid black;">Courses</th>
	            <th style="padding: 8px; border: 1px solid black;">Next Quarter Offered</th>
	        </tr>
	        <% for (String c : notTakenCourses) { %>
		        <%
		        String get_next_offered_quarters = 
		        "SELECT * FROM section \n" + 
		        "WHERE coursenumber = '" + c + "' \n" +
		        "AND ((classyear = 2018 AND classquarter = 'FALL') OR classyear > 2018)";
		        rs = stmt.executeQuery(get_next_offered_quarters);
		        
		        String nextQuarter = null;
		        String nextYear = null;
		        while (rs.next()) {
		            String year = rs.getString("classYear");
		            String quarter = rs.getString("classQuarter");
		            if (nextYear == null || nextQuarter == null) {
		                nextYear = year;
		                nextQuarter = quarter;
		            }
		            if (year.equals("2018") && quarter.equals("FALL")) {
		                nextYear = "2018";
		                nextQuarter = "FALL";
		                break;
		            }
		            else if (Integer.parseInt(year) < Integer.parseInt(nextYear)) {
		                nextYear = year;
		                nextQuarter = quarter;
		            }
		            else if (Integer.parseInt(year) == Integer.parseInt(nextYear)) {
		                if (quarter.equals("WINTER") && (nextQuarter.equals("SPRING") || nextQuarter.equals("FALL"))) {
		                    nextYear = year;
			                nextQuarter = quarter;
		                }
		                else if (quarter.equals("SPRING") && nextQuarter.equals("FALL")) {
		                    nextYear = year;
			                nextQuarter = quarter;
		                }
		            }
		        }
		        if (nextQuarter == null || nextYear == null) {
		            nextQuarter = "Not planned to be";
		            nextYear = "offered yet";
		        }
		        %>
	        
	        <tr style="border: 1px solid black;">
	            <td style="padding: 8px; border: 1px solid black;"><%= c %></td>
	            <td style="padding: 8px; border: 1px solid black;"><%= nextQuarter + " " + nextYear %></td>
	        </tr>
	        <% } %>
	    </table>
	    <br>
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
	
	<%
	/* 
	
	
	// concentrations and what courses the masters student has completed under them
	Map<String, List<String>> conmap = new HashMap<>();
	String query_completed_courses = null;
	for (String c : concentrations) {
	    query_completed_courses = 
           "SELECT \n" +
           "FROM ConcentrationCourses c, pasttake p \n" +
	    "WHERE p.st_id = '" + studentID + "' \n" +
           "AND p.cr_courseNumber = c.cr_courseNumber \n" +
	    "AND (p.pasttake_grade = 'A+' \n" + 
           "OR   p.pasttake_grade = 'A'  \n" +
           "OR   p.pasttake_grade = 'A-' \n" +
           "OR   p.pasttake_grade = 'B+' \n" +
           "OR   p.pasttake_grade = 'B'  \n" +
           "OR   p.pasttake_grade = 'B-' \n" +
           "OR   p.pasttake_grade = 'C+' \n" +
           "OR   p.pasttake_grade = 'C'  \n" +
           "OR   p.pasttake_grade = 'C-')";
	}
	
	// random test code
	
	SELECT p.cr_courseNumber AS courseNum, p.pasttake_gradingOption AS gradingOption,p.pasttake_units AS units, p.pasttake_grade AS grade FROM ConcentrationCourses c, pasttake p WHERE p.st_id = 'A12345678' AND p.cr_courseNumber = c.cr_courseNumber;
	
	*/
	
	%>
	
	<br>
	<a href="./ms3_01e_SelectMasterAndMSDegree.jsp">Back to selection page</a>
	<br>
	<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>