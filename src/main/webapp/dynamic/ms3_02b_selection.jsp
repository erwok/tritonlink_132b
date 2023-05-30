<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Select Section for Scheduling Review Sessions</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*" %>
	<h2>Section Selection for Scheduling Review Sessions (Spring 2018)</h2>
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
	String get_current_quarter_dates =
	"SELECT * FROM QuarterDates WHERE quarter = 'SPRING' AND year = 2018";
	
	ResultSet rs = stmt.executeQuery(get_current_quarter_dates);
	rs.next();
	String start_date = rs.getString("start_date");
	String end_date = rs.getString("end_date");
	
	String get_currently_offered_sections = 
    "SELECT * FROM Section WHERE classQuarter = 'SPRING' AND classYear = 2018";
	rs = stmt.executeQuery(get_currently_offered_sections);
	%>
	
	
	<h4>Select Section Based on Section ID and Course Number</h4>
	<table>
		<tr>
			<form action="ms3_02b_select_period.jsp" method="get">
			    <input type="hidden" value="select" name="action">
			    <td>
			        <select name="sectionID">
			            <option value="" selected disabled>Select section</option>
			            <% while (rs.next()) {
			                String sectionID = rs.getString("s_sectionID");
			            %>
			                <option value="<%= sectionID %>"><%= "Section ID: " + sectionID + ", Course Number: " + rs.getString("courseNumber") %></option>
			            <% } %>
			        </select>
			    </td>
			    <th><input type="submit" value="Select"></th>
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