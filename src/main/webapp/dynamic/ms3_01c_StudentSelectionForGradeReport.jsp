<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Select Student</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*" %>
	<h2>Get Student's Current Classes Report</h2>
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
	String GET_Currently_enrolled_students_QUERY = 
	"SELECT s.st_id, s.st_ssn, s.st_firstname, s.st_middlename, \n" +
	"s.st_lastname FROM Student s, Taker t WHERE s.st_ID = t.st_ID";
	ResultSet rs = stmt.executeQuery(GET_Currently_enrolled_students_QUERY);
	%>
	
	
	<h4>Select Student Based on SSN</h4>
	<table>
		<tr>
			<form action="ms3_01a_StudentCurrentClasses.jsp" method="get">
			    <input type="hidden" value="select" name="action">
			    <td>
			        <select name="st_id">
			            <option value="" selected disabled>Select student</option>
			            <% while (rs.next()) {
			                String st_ssn = rs.getString("st_ssn");
			                String f = rs.getString("st_firstname");
			                String m = rs.getString("st_middlename");
			                String l = rs.getString("st_lastname");
			                String fullName = f + " " + m + " " + l;
			            %>
			                <option value="<%= rs.getString("st_id") + "," + fullName %>"><%= "SSN: " + st_ssn + ", Name: " + fullName %></option>
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