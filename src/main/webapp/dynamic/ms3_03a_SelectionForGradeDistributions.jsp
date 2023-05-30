<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Grade Distributions Option Selection Page</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*" %>
	<h1>Grade Distributions Option Selection Page</h1>
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
	
	<style>
	    table {
	        border-collapse: collapse;
	    }
	
	    th, td {
	        border: 1px solid black;
	        padding: 8px;
	        text-align: left;
	    }
	</style>
	
	<%
	ResultSet rs;
	%>
	
	<br>
	<h4>1. Counts of Grades based on Course ID, Professor, and Quarter</h4>
	<table>
	    <tr>
	        <th>Course Number</th>
	        <th>Professor</th>
	        <th>Quarter</th>
	        <th>Year</th>
	    </tr>
	    <tr>
	        <form action="ms3_03a_query1.jsp" method="get">
	            <%
	            String get_courses = "SELECT cr_coursenumber AS courseNum FROM course ORDER BY cr_courseNumber";
	            rs = stmt.executeQuery(get_courses);
	            %>
	            <td><select name="courseNum">
	                <option value="" selected disabled>Select Course</option>
	                <% while (rs.next()) { %>
	                    <option value="<%= rs.getString("courseNum") %>"><%= rs.getString("courseNum") %></option>
	                <% } %>
	            </select></td>
	
	            <%
	            String get_professors = "SELECT fc_name AS professor FROM faculty ORDER BY fc_name";
	            rs = stmt.executeQuery(get_professors);
	            %>
	
	            <td><select name="professor">
	                <option value="" selected disabled>Select Professor</option>
	                <% while (rs.next()) { %>
	                    <option value="<%= rs.getString("professor") %>"><%= rs.getString("professor") %></option>
	                <% } %>
	            </select></td>
	
	            <td><input name="quarter" value=""></td>
	            <td><input name="year" value=""></td>
	            <td><input type="submit" value="Select"></td>
	        </form>
	    </tr>
	</table>
	
	<br>
	<h4>2. Counts of Grades based on Course ID and Professor</h4>
	<table>
	    <tr>
	        <th>Course Number</th>
	        <th>Professor</th>
	    </tr>
	    <tr>
	        <form action="ms3_03a_query2.jsp" method="get">
	            <%
	            rs = stmt.executeQuery(get_courses);
	            %>
	            <td><select name="courseNum">
	                <option value="" selected disabled>Select Course</option>
	                <% while (rs.next()) { %>
	                    <option value="<%= rs.getString("courseNum") %>"><%= rs.getString("courseNum") %></option>
	                <% } %>
	            </select></td>
	            <%
	            rs = stmt.executeQuery(get_professors);
	            %>
	            <td><select name="professor">
	                <option value="" selected disabled>Select Professor</option>
	                <% while (rs.next()) { %>
	                    <option value="<%= rs.getString("professor") %>"><%= rs.getString("professor") %></option>
	                <% } %>
	            </select></td>
	            <td><input type="submit" value="Select"></td>
	        </form>
	    </tr>
	</table>
	
	<br>
	<h4>3. Counts of Grades based on Course ID</h4>
	<table>
	    <tr>
	        <th>Course Number</th>
	    </tr>
	    <tr>
	        <form action="ms3_03a_query3.jsp" method="get">
	            <%
	            rs = stmt.executeQuery(get_courses);
	            %>
	            <td><select name="courseNum">
	                <option value="" selected disabled>Select Course</option>
	                <% while (rs.next()) { %>
	                    <option value="<%= rs.getString("courseNum") %>"><%= rs.getString("courseNum") %></option>
	                <% } %>
	            </select></td>
	            <td><input type="submit" value="Select"></td>
	        </form>
	    </tr>
	</table>
	
	<br>
	<h4>4. GPA based on Course ID and Professor</h4>
	<table>
	    <tr>
	        <th>Course Number</th>
	        <th>Professor</th>
	    </tr>
	    <tr>
	        <form action="ms3_03a_query4.jsp" method="get">
	            <%
	            rs = stmt.executeQuery(get_courses);
	            %>
	            <td><select name="courseNum">
	                <option value="" selected disabled>Select Course</option>
	                <% while (rs.next()) { %>
	                    <option value="<%= rs.getString("courseNum") %>"><%= rs.getString("courseNum") %></option>
	                <% } %>
	            </select></td>
	            <%
	            rs = stmt.executeQuery(get_professors);
	            %>
	            <td><select name="professor">
	                <option value="" selected disabled>Select Professor</option>
	                <% while (rs.next()) { %>
	                    <option value="<%= rs.getString("professor") %>"><%= rs.getString("professor") %></option>
	                <% } %>
	            </select></td>
	            <td><input type="submit" value="Select"></td>
	        </form>
	    </tr>
	</table>
	
	<%		
	rs.close();
	
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
	
	<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>