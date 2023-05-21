<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String studentID = request.getParameter("st_ID");
%>
<title>Get Student <%= studentID %>'s Current Classes</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*" %>

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
	
		String GET_current_classes_QUERY = 
	        "SELECT * FROM Taker \n" + 
			"WHERE st_id = '" + studentID + "'";
		ResultSet rs = stmt.executeQuery(GET_current_classes_QUERY);
	%>
	
	
	
	<table>
		<tr>
			<th></th>
		</tr>
	<%
		while (rs.next()) {    
	%>
		<tr>
			
		</tr>

	<%
		}
	%>
	</table>
	
	<%
	// Close the ResultSet
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

</body>
</html>

<!--
	Display the classes currently taken by student X:

a. The form is an HTML SELECT control with all students enrolled in the current quarter.   
Display the SSN, FIRSTNAME, MIDDLENAME and LASTNAME attributes of STUDENTs given their SSN attribute.

b. The report should display the classes taken by X in the current quarter.

c. On the report page display all attributes of the CLASS entity and the UNITS and 
SECTION attributes of the relationship connecting STUDENTS with the CLASS they take.
	
Given ssn of a student = <ssn>

a. SELECT S.* FROM Student S, Taker T WHERE T.st_ssn = '<ssn>' AND S.st_id = T.st_id;

b. SELECT T.* FROM Take T WHERE st_ssn = '<ssn>';

c. SELECT C.* FROM Course C, Take T where C.cr_coursenumber = T.cr_coursenumber;

-->