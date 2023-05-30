<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Select Professor</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*" %>
	<h2>Professor Selection for Current Class Review Session Scheduling Help</h2>
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
	String GET_Currently_teach_professor_QUERY = 

	"SELECT t.* FROM Faculty f, Teaches t, Section s \n" +
	"WHERE f.fc_name = t.fc_name AND t.s_sectionid = s.s_sectionid AND classyear = 2018 AND classquarter = 'SPRING'";

	ResultSet rs = stmt.executeQuery(GET_Currently_teach_professor_QUERY);
	%>
	
	
	<h4>Professor Based on s_sectionid</h4>
	<table>
		<tr>
			<th>Section w/ Professor</th>
			<th>Start Month</th>			
			<th>Start Date</th>
			<th>End Month</th>
			<th>End Date</th>
		</tr>
		<tr>
			<form action="ms3_02b_ProfReviewSchedulingHelp.jsp" method="get">
			    <input type="hidden" value="select" name="action">
			    <td>
			        <select name="fc_name">
			            <option value="" selected disabled>Select Professor</option>
			            <% while (rs.next()) {
			                String s_sectionid = rs.getString("s_sectionid");
			                String fc_name = rs.getString("fc_name");
			            %>
			                <option value="<%= rs.getString("fc_name") + "," + rs.getString("s_sectionid") %>"><%= "Name: " + fc_name  + ", section: " + s_sectionid%></option>
			            <% } %>				
						<td><input value="" name="startMonth" size="10"></td>
						<td><input value="" name="startDate" size="10"></td>
						<td><input value="" name="endMonth" size="10"></td>	
						<td><input value="" name="endDate" size="10"></td>						
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