<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Select Class</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*" %>
	<h2>Get Class Section's Roster</h2>
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
	
	<%
	String GET_Class_Sections_QUERY = 
	"SELECT * from section";
	ResultSet rs = stmt.executeQuery(GET_Class_Sections_QUERY);
	%>
	
	
	<h4>Select Class Section Based on Title</h4>
	<table>
		<tr>
			<form action="ms3_01b_ClassRoster.jsp" method="get">
			    <input type="hidden" value="select" name="action">
			    <td>
			        <select name="section_stuff">
			            <option value="" selected disabled>Select Class Section</option>
			            <% while (rs.next()) {
			                String courseNumber = rs.getString("courseNumber");
			                String classTitle = rs.getString("classTitle");
			                String classYear = rs.getString("classYear");
			                String classQuarter = rs.getString("classQuarter");
			                String s_sectionID = rs.getString("s_sectionID");
			                String everything = courseNumber + "," + classTitle + "," + classYear + "," + classQuarter + "," + s_sectionID;
			            %>
			                <option value="<%= everything %>">
			                <%= "TITLE: " + classTitle + ", COURSE: " + courseNumber + ", QUARTER: " + classQuarter + ", YEAR: " + classYear + ", SECTION: " + s_sectionID %>
			                </option>
			            <% } %>
			        </select>
			    </td>
			    <th><input type="submit" value="Select"></th>
			</form>
		</tr>
	</table>
	

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
	
	<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>