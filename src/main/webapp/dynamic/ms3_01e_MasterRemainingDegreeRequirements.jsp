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
		Map<String, List<String>> conmap = new HashMap<>();
		String query_completed_courses = null;
		for (String c : concentrations) {
		    query_completed_courses = 
            "SELECT p.cr_courseNumber AS courseNum, p.pasttake_gradingOption AS gradingOption, \n" +
		    "p.pasttake_units AS units, p.pasttake_grade AS grade \n" +
            "FROM ConcentrationCourses c, pasttake p \n" +
		    "WHERE p.st_id = '" + studentID + "' \n" +
            "AND p.cr_courseNumber = c.cr_courseNumber";
		    rs = stmt.executeQuery(query_completed_courses);
		    
		    List<String> courses = null;
		    while (rs.next()) {
		        if (conmap.get(c) == null) {
		            List<String> l = new ArrayList<>();
		            conmap.put(c, l);
		        }
		        courses = conmap.get(c);
		        courses.add(rs.getString("cr_courseNumber"));
		    }
		}
		
	%>





<%-- 	
	<%
	for (Map.Entry<String, List<String>> entry : concentrationCourses.entrySet()) {
        String key = entry.getKey();
       	List<String> value = entry.getValue();
        
       	for (String t : value) {
       	%> 
       		<b><%= t %></b>
       	<%  
       	}
       	
    }
	
	
	%> --%>
	
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
	
	
	
	*/
	
	
	%>
	
	
	<br>
	<a href="./ms3_01e_SelectMasterAndMSDegree.jsp">Back to selection page</a>
	<br>
	<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>