<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Student Entry Page</title>
</head>
<body>
			<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<b>Student Entry Page</b>
			
			<table>
				<tr>
					<th>ID</th>
					<th>SSN</th>
					<th>EnrollmentStatus</th>
					<th>Residential</th>
					<th>First Name</th>
					<th>Middle Name</th>
					<th>Last Name</th>
					<th>Academic Status</th>
				</tr>
				<%
				try {
				    // Load driver
				    DriverManager.registerDriver(new org.postgresql.Driver());
				    
				    // Make a connection to the Oracle datasource
				    Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlink?user=postgres&password=helloworld");
				%>
				
				<!-- Insertion stuff? -->
				<%
					// Check if an insertion is required
					String action = request.getParameter("action");
					if (action != null && action.equals("insert")) {
					    
					    connection.setAutoCommit(false);
					    
					    // Create the prepared statement and use it to
					    // INSERT the Student attrs INTO the Student table
					    PreparedStatement pstmt = connection.prepareStatement(
					    ("INSERT INTO Student VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));

					    pstmt.setString(1, request.getParameter("st_ID"));
					    pstmt.setString(2, request.getParameter("st_SSN"));
					    pstmt.setString(3, request.getParameter("st_enrollmentStatus"));
					    pstmt.setString(4, request.getParameter("st_residential"));
					    pstmt.setString(5, request.getParameter("st_firstName"));
					    pstmt.setString(6, request.getParameter("st_middleName"));
					    pstmt.setString(7, request.getParameter("st_lastName"));
					    pstmt.setString(8, request.getParameter("academic_status"));
					    
					    pstmt.executeUpdate();
					    
					    // Stuff based on academic status
					    PreparedStatement pstmt2 = null;
					    
					    String academic_status = request.getParameter("academic_status");
					    if (academic_status.equals("Undergraduate")) {
					        pstmt2 = connection.prepareStatement("INSERT INTO Undergraduate VALUES (?, ?)");
					        
					        pstmt2.setString(1, request.getParameter("st_ID"));
					        pstmt2.setString(2, "Not set yet");
					    }
					    else if (academic_status.equals("Master")) {
							pstmt2 = connection.prepareStatement("INSERT INTO Master VALUES (?, ?)");
					        
					        pstmt2.setString(1, request.getParameter("st_ID"));
					        pstmt2.setString(2, "Not set yet");
					    }
					    else if (academic_status.equals("Precandidate")) {
							pstmt2 = connection.prepareStatement("INSERT INTO Precandidate VALUES (?)");
					        
					        pstmt2.setString(1, request.getParameter("st_ID"));
					        
					    }
					    else if (academic_status.equals("Candidate")) {
							pstmt2 = connection.prepareStatement("INSERT INTO Candidate VALUES (?, ?)");
					        
					        pstmt2.setString(1, request.getParameter("st_ID"));
					        pstmt2.setString(2, "Not set yet");
					    }
					    pstmt2.executeUpdate();
					    
					    
					    connection.commit();
					    connection.setAutoCommit(true);
					}
				
				%>
				
				<!-- Update stuff? -->
				<%
				// Check if an update is requested
				if (action != null && action.equals("update")) {
				    
				    connection.setAutoCommit(false);
				    
				    // Create the prepared statement and use it to
				    // UPDATE the Student attributes in the Student table.
				    PreparedStatement pstatement = connection.prepareStatement(
				    	"UPDATE Student SET st_ID = ?, st_SSN = ?, st_enrollmentStatus = ?, st_residential = ?, st_firstName = ?, st_middleName = ?, st_lastName = ?, academic_status = ? \n"+
				    	"WHERE st_ID = ?"
				    );
				    
				    pstatement.setString(1, request.getParameter("st_ID"));
				    pstatement.setString(2, request.getParameter("st_SSN"));
				    pstatement.setString(3, request.getParameter("st_enrollmentStatus"));
				    pstatement.setString(4, request.getParameter("st_residential"));
				    pstatement.setString(5, request.getParameter("st_firstName"));
				    pstatement.setString(6, request.getParameter("st_middleName"));
				    pstatement.setString(7, request.getParameter("st_lastName"));
				    pstatement.setString(8, request.getParameter("academic_status"));
				    pstatement.setString(9, request.getParameter("st_ID"));
				    pstatement.executeUpdate();
				    
				    if (!request.getParameter("previous_academic_status").equals(request.getParameter("academic_status"))) {
			        	// if we change academic status, we have to delete the student from the relation of their old academic status
				        PreparedStatement pstmt14 = connection.prepareStatement(
		            		"DELETE FROM ThesisCommittee WHERE st_id = ?"
			            );
					    pstmt14.setString(1, request.getParameter("st_ID"));
					    pstmt14.executeUpdate();
					    
					    PreparedStatement pstmt13 = connection.prepareStatement(
		            		"DELETE FROM Candidate WHERE st_id = ?"
			            );
					    pstmt13.setString(1, request.getParameter("st_ID"));
					    pstmt13.executeUpdate();
					    
					    PreparedStatement pstmt12 = connection.prepareStatement(
		            		"DELETE FROM Precandidate WHERE st_id = ?"
			            );
					    pstmt12.setString(1, request.getParameter("st_ID"));
					    pstmt12.executeUpdate();
					    
					    PreparedStatement pstmt11 = connection.prepareStatement(
		            		"DELETE FROM Master WHERE st_id = ?"
			            );
					    pstmt11.setString(1, request.getParameter("st_ID"));
					    pstmt11.executeUpdate();
					    
					    PreparedStatement pstmt10 = connection.prepareStatement(
		            		"DELETE FROM Undergraduate WHERE st_id = ?"
			            );
					    pstmt10.setString(1, request.getParameter("st_ID"));
					    pstmt10.executeUpdate();
				        
				        
				        // Stuff based on academic status
					    PreparedStatement pstmt2 = null;
					    
					    String academic_status = request.getParameter("academic_status");
					    if (academic_status.equals("Undergraduate")) {
					        pstmt2 = connection.prepareStatement("INSERT INTO Undergraduate VALUES (?, ?)");
					        
					        pstmt2.setString(1, request.getParameter("st_ID"));
					        pstmt2.setString(2, "Not set yet");
					    }
					    else if (academic_status.equals("Master")) {
							pstmt2 = connection.prepareStatement("INSERT INTO Master VALUES (?, ?)");
					        
					        pstmt2.setString(1, request.getParameter("st_ID"));
					        pstmt2.setString(2, "Not set yet");
					    }
					    else if (academic_status.equals("Precandidate")) {
							pstmt2 = connection.prepareStatement("INSERT INTO Precandidate VALUES (?)");
					        
					        pstmt2.setString(1, request.getParameter("st_ID"));
					        
					    }
					    else if (academic_status.equals("Candidate")) {
							pstmt2 = connection.prepareStatement("INSERT INTO Candidate VALUES (?, ?)");
					        
					        pstmt2.setString(1, request.getParameter("st_ID"));
					        pstmt2.setString(2, "Not set yet");
					    }
					    pstmt2.executeUpdate();
				    }
				    
				 	
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
				<!-- Update Undergraduate -->
				<%
				// Check if an update is requested
				if (action != null && action.equals("update_undergraduate")) {
				    
				    connection.setAutoCommit(false);
				    
				    // Create the prepared statement and use it to
				    // UPDATE the Student attributes in the Student table.
				    PreparedStatement pstatement = connection.prepareStatement(
			            "UPDATE Undergraduate SET major = ?, minor = ? WHERE st_ID = ?"
				    );
				    
				    pstatement.setString(1, request.getParameter("major"));
				    pstatement.setString(2, request.getParameter("minor"));
				    pstatement.setString(3, request.getParameter("st_ID"));
				    pstatement.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
				<!-- Update Master -->
				<%
				// Check if an update is requested
				if (action != null && action.equals("update_master")) {
				    
				    connection.setAutoCommit(false);
				    
				    // Create the prepared statement and use it to
				    // UPDATE the Student attributes in the Student table.
				    PreparedStatement pstatement = connection.prepareStatement(
			            "UPDATE Master SET department = ? WHERE st_ID = ?"
				    );
				    
				    pstatement.setString(1, request.getParameter("department"));
				    pstatement.setString(2, request.getParameter("st_ID"));
				    pstatement.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
				<!-- Update Candidate -->
				<%
				// Check if an update is requested
				if (action != null && action.equals("update_candidate")) {
				    
				    connection.setAutoCommit(false);
				    
				    // Create the prepared statement and use it to
				    // UPDATE the Student attributes in the Student table.
				    PreparedStatement pstatement = connection.prepareStatement(
			            "UPDATE Candidate SET advisor = ? WHERE st_ID = ?"
				    );
				    
				    pstatement.setString(1, request.getParameter("advisor"));
				    pstatement.setString(2, request.getParameter("st_ID"));
				    pstatement.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
				
				
				<!-- Delete stuff? -->
				<%
				// Check if a delete is requested
				if (action != null && action.equals("delete")) {
				    
				    connection.setAutoCommit(false);	
				    
				    PreparedStatement pstmt14 = connection.prepareStatement(
	            		"DELETE FROM ThesisCommittee WHERE st_id = ?"
		            );
				    pstmt14.setString(1, request.getParameter("st_ID"));
				    pstmt14.executeUpdate();
				    
				    PreparedStatement pstmt13 = connection.prepareStatement(
	            		"DELETE FROM Candidate WHERE st_id = ?"
		            );
				    pstmt13.setString(1, request.getParameter("st_ID"));
				    pstmt13.executeUpdate();
				    
				    PreparedStatement pstmt12 = connection.prepareStatement(
	            		"DELETE FROM Precandidate WHERE st_id = ?"
		            );
				    pstmt12.setString(1, request.getParameter("st_ID"));
				    pstmt12.executeUpdate();
				    
				    PreparedStatement pstmt11 = connection.prepareStatement(
	            		"DELETE FROM Master WHERE st_id = ?"
		            );
				    pstmt11.setString(1, request.getParameter("st_ID"));
				    pstmt11.executeUpdate();
				    
				    PreparedStatement pstmt10 = connection.prepareStatement(
	            		"DELETE FROM Undergraduate WHERE st_id = ?"
		            );
				    pstmt10.setString(1, request.getParameter("st_ID"));
				    pstmt10.executeUpdate();
				    
				    PreparedStatement pstmt9 = connection.prepareStatement(
	            		"DELETE FROM pastTake WHERE st_id = ?"
		            );
				    pstmt9.setString(1, request.getParameter("st_ID"));
				    pstmt9.executeUpdate();
				    
				    PreparedStatement pstmt8 = connection.prepareStatement(
	            		"DELETE FROM pastTaker WHERE st_id = ?"
		            );
				    pstmt8.setString(1, request.getParameter("st_ID"));
				    pstmt8.executeUpdate();

			    	PreparedStatement pstmt7 = connection.prepareStatement(
		    	        "DELETE FROM Probation WHERE st_id = ?"
	            	);
			    	pstmt7.setString(1, request.getParameter("st_ID"));
				    pstmt7.executeUpdate();
				    
				    PreparedStatement pstmt6 = connection.prepareStatement(
		    	        "DELETE FROM Probator WHERE st_id = ?"
	            	);
			    	pstmt6.setString(1, request.getParameter("st_ID"));
				    pstmt6.executeUpdate();
				    
				    /* PreparedStatement pstmt5 = connection.prepareStatement(
		            	"DELETE FROM Student_section WHERE st_id = ?"
		            );
				    pstmt5.setString(1, request.getParameter("st_ID"));
				    pstmt5.executeUpdate();
				    
				    PreparedStatement pstmt4 = connection.prepareStatement(
			            "DELETE FROM Student_enrollment WHERE st_id = ?"
		            );
				    pstmt4.setString(1, request.getParameter("st_ID"));
				    pstmt4.executeUpdate(); */
				    
				    PreparedStatement pstmt2 = connection.prepareStatement(
	            		"DELETE FROM Take WHERE st_id = ?"
		            );
				    pstmt2.setString(1, request.getParameter("st_ID"));
				    pstmt2.executeUpdate();
				    
				    PreparedStatement pstmt3 = connection.prepareStatement(
	            		"DELETE FROM Taker WHERE st_id = ?"
		            );
				    pstmt3.setString(1, request.getParameter("st_ID"));
				    pstmt3.executeUpdate();
				    
				    // Create the prepared statement and use it to
				    // DELETE the Student FROM the Student table.
				    PreparedStatement pstmt = connection.prepareStatement(
				    	"DELETE FROM Student \n"+
				    	"WHERE st_ID = ? AND st_SSN = ? AND st_enrollmentStatus = ? AND st_residential = ? AND st_firstName = ? AND st_middleName = ? AND st_lastName = ?"
				    );
				    
				    pstmt.setString(1, request.getParameter("st_ID"));
				    pstmt.setString(2, request.getParameter("st_SSN"));
				    pstmt.setString(3, request.getParameter("st_enrollmentStatus"));
				    pstmt.setString(4, request.getParameter("st_residential"));
				    pstmt.setString(5, request.getParameter("st_firstName"));
				    pstmt.setString(6, request.getParameter("st_middleName"));
				    pstmt.setString(7, request.getParameter("st_lastName"));
				    int rowCount = pstmt.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
					
				<%
					Statement stmt = connection.createStatement();
				
					String GET_Student_QUERY = "SELECT * FROM Student";
					ResultSet rs = stmt.executeQuery(GET_Student_QUERY);
				%>
				
				<tr>
					<form action="03_StudentEntry.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<td><input value="" name="st_ID"></td>
						<td><input value="" name="st_SSN"></td>
						<td><input value="" name="st_enrollmentStatus"></td>
						<td><input value="" name="st_residential"></td>
						<td><input value="" name="st_firstName"></td>
						<td><input value="" name="st_middleName"></td>
						<td><input value="" name="st_lastName"></td>
						<td><select name="academic_status">
                          <option value="Undergraduate" selected>Undergraduate</option>
                          <option value="Master">Master</option>
                          <option value="Precandidate">PhD Precandidate</option>
                          <option value="Candidate">PhD Candidate</option>
                        </select></td>
						<td><input type="submit" value="Insert"></td>
					</form>
				</tr>
				
				<!-- Iteration stuff? -->
				<%
				rs = stmt.executeQuery(
					"SELECT * FROM Student \n"+
					"ORDER BY st_ID, st_SSN, st_firstName, st_middleName, st_lastName"
				);
				
				while (rs.next()) {
				%>
				<tr>
					<form action="03_StudentEntry.jsp" method="get">
						<input type="hidden" value="update" name="action">
						<input type="hidden" name="previous_academic_status" value="<%= rs.getString("academic_status") %>">
						<td><input value="<%= rs.getString("st_ID") %>" name="st_ID"></td>
						<td><input value="<%= rs.getString("st_SSN") %>" name="st_SSN"></td>
						<td><input value="<%= rs.getString("st_enrollmentStatus") %>" name="st_enrollmentStatus"></td>
						<td><input value="<%= rs.getString("st_residential") %>" name="st_residential"></td>
						<td><input value="<%= rs.getString("st_firstName") %>" name="st_firstName"></td>
						<td><input value="<%= rs.getString("st_middleName") %>" name="st_middleName"></td>
						<td><input value="<%= rs.getString("st_lastName") %>" name="st_lastName"></td>
						<td><select name="academic_status">
                       	  <% String as = rs.getString("academic_status"); %>
                          <option value="Undergraduate" <%= (as.equals("Undergraduate")) ? "selected":""%>>Undergraduate</option>
                          <option value="Master" <%= (as.equals("Master")) ? "selected":""%>>Master</option>
                          <option value="Precandidate" <%= (as.equals("Precandidate")) ? "selected":""%>>Precandidate</option>
                          <option value="Candidate" <%= (as.equals("Candidate")) ? "selected":""%>>Candidate</option>
                        </select></td>
						<td><input type="submit" value="Update"></td>
					</form>
					<form action="03_StudentEntry.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= rs.getString("st_ID") %>" name="st_ID">
						<input type="hidden" value="<%= rs.getString("st_SSN") %>" name="st_SSN">
						<input type="hidden" value="<%= rs.getString("st_enrollmentStatus") %>" name="st_enrollmentStatus">
						<input type="hidden" value="<%= rs.getString("st_residential") %>" name="st_residential">
						<input type="hidden" value="<%= rs.getString("st_firstName") %>" name="st_firstName">
						<input type="hidden" value="<%= rs.getString("st_middleName") %>" name="st_middleName">
						<input type="hidden" value="<%= rs.getString("st_lastName") %>" name="st_lastName">
						<td><input type="submit" value="Delete"></td>
					</form>
				</tr>
				<%
				}
				%>
				
			</table>
			
			<br>
			<h3>Undergraduates</h3>
			<table style="border-collapse: collapse; width: 80%; table-layout: fixed;">
			    <colgroup>
			        <col style="width: 10%;">
			        <col style="width: 20%;">
			        <col style="width: 20%;">
			        <col style="width: 20%;">
			        <col style="width: 15%;">
			        <col style="width: 15%;">
			    </colgroup>
			    <tr style="background-color: #f2f2f2;">
			        <th style="padding: 10px; border: 1px solid #ddd;">ID</th>
			        <th style="padding: 10px; border: 1px solid #ddd;">First Name</th>
			        <th style="padding: 10px; border: 1px solid #ddd;">Middle Name</th>
			        <th style="padding: 10px; border: 1px solid #ddd;">Last Name</th>
			        <th style="padding: 10px; border: 1px solid #ddd;">Major</th>
			        <th style="padding: 10px; border: 1px solid #ddd;">Minor</th>
			    </tr>
			<%
			rs = stmt.executeQuery(
			    "SELECT u.st_ID AS st_ID, s.st_firstName AS f, s.st_middleName AS m, s.st_lastName AS l, u.major AS major, u.minor AS minor \n" +
			    "FROM Undergraduate u, Student s \n" +
			    "WHERE u.st_ID = s.st_ID \n" +
			    "ORDER BY s.st_firstName, s.st_middleName, s.st_lastName, u.st_ID"
			);
			
			while (rs.next()) {
			%>
			    <tr>
			        <form action="03_StudentEntry.jsp" method="get">
			            <input type="hidden" value="update_undergraduate" name="action">
			            <input type="hidden" name="st_ID" value="<%= rs.getString("st_ID") %>">
			            <td style="padding: 10px; border: 1px solid #ddd;"><%= rs.getString("st_ID") %></td>
			            <td style="padding: 10px; border: 1px solid #ddd;"><%= rs.getString("f") %></td>
			            <td style="padding: 10px; border: 1px solid #ddd;"><%= rs.getString("m") %></td>
			            <td style="padding: 10px; border: 1px solid #ddd;"><%= rs.getString("l") %></td>
			            <td style="padding: 10px; border: 1px solid #ddd;"><input value="<%= rs.getString("major") %>" name="major"></td>
			            <td style="padding: 10px; border: 1px solid #ddd;"><input value="<%= rs.getString("minor") %>" name="minor"></td>
			            <td style="padding: 10px; border: 1px solid #ddd;"><input type="submit" value="Update"></td>
			        </form>
			    </tr>
			<%
			}
			%>
			</table>
			
			<br>
			<h3>Master</h3>
			<table style="border-collapse: collapse; width: 80%; table-layout: fixed;">
			    <colgroup>
			        <col style="width: 10%;">
			        <col style="width: 20%;">
			        <col style="width: 20%;">
			        <col style="width: 20%;">
			        <col style="width: 30%;">
			    </colgroup>
			    <tr style="background-color: #f2f2f2;">
			        <th style="padding: 10px; border: 1px solid #ddd;">ID</th>
			        <th style="padding: 10px; border: 1px solid #ddd;">First Name</th>
			        <th style="padding: 10px; border: 1px solid #ddd;">Middle Name</th>
			        <th style="padding: 10px; border: 1px solid #ddd;">Last Name</th>
			        <th style="padding: 10px; border: 1px solid #ddd;">Department</th>
			    </tr>
			<%
			rs = stmt.executeQuery(
			    "SELECT mas.st_ID AS st_ID, s.st_firstName AS f, s.st_middleName AS m, s.st_lastName AS l, mas.department AS department \n" +
			    "FROM Master mas, Student s \n" +
			    "WHERE mas.st_ID = s.st_ID \n" +
			    "ORDER BY s.st_firstName, s.st_middleName, s.st_lastName, mas.st_ID"
			);
			
			while (rs.next()) {
			%>
			    <tr>
			        <form action="03_StudentEntry.jsp" method="get">
			            <input type="hidden" value="update_master" name="action">
			            <input type="hidden" name="st_ID" value="<%= rs.getString("st_ID") %>">
			            <td style="padding: 10px; border: 1px solid #ddd;"><%= rs.getString("st_ID") %></td>
			            <td style="padding: 10px; border: 1px solid #ddd;"><%= rs.getString("f") %></td>
			            <td style="padding: 10px; border: 1px solid #ddd;"><%= rs.getString("m") %></td>
			            <td style="padding: 10px; border: 1px solid #ddd;"><%= rs.getString("l") %></td>
			            <td style="padding: 10px; border: 1px solid #ddd;"><input value="<%= rs.getString("department") %>" name="department"></td>
			            <td style="padding: 10px; border: 1px solid #ddd;"><input type="submit" value="Update"></td>
			        </form>
			    </tr>
			<%
			}
			%>
			</table>
			
			<br>
			<h3>Precandidates</h3>
			<table style="border-collapse: collapse; width: 80%; table-layout: fixed;">
			    <colgroup>
			        <col style="width: 10%;">
			        <col style="width: 20%;">
			        <col style="width: 20%;">
			        <col style="width: 20%;">
			    </colgroup>
			    <tr style="background-color: #f2f2f2;">
			        <th style="padding: 10px; border: 1px solid #ddd;">ID</th>
			        <th style="padding: 10px; border: 1px solid #ddd;">First Name</th>
			        <th style="padding: 10px; border: 1px solid #ddd;">Middle Name</th>
			        <th style="padding: 10px; border: 1px solid #ddd;">Last Name</th>
			    </tr>
			<%
			rs = stmt.executeQuery(
			    "SELECT pc.st_ID AS st_ID, s.st_firstName AS f, s.st_middleName AS m, s.st_lastName AS l \n" +
			    "FROM Precandidate pc, Student s \n" +
			    "WHERE pc.st_ID = s.st_ID \n" +
			    "ORDER BY s.st_firstName, s.st_middleName, s.st_lastName, pc.st_ID"
			);
			
			while (rs.next()) {
			%>
			    <tr>
			        <td style="padding: 10px; border: 1px solid #ddd;"><%= rs.getString("st_ID") %></td>
			        <td style="padding: 10px; border: 1px solid #ddd;"><%= rs.getString("f") %></td>
			        <td style="padding: 10px; border: 1px solid #ddd;"><%= rs.getString("m") %></td>
			        <td style="padding: 10px; border: 1px solid #ddd;"><%= rs.getString("l") %></td>
			    </tr>
			<%
			}
			%>
			</table>
			
			<br>
			<h3>Candidates</h3>
			<table style="border-collapse: collapse; width: 80%; table-layout: fixed;">
			    <tr style="background-color: #f2f2f2;">
			        <th style="padding: 10px; border: 1px solid #ddd;">ID</th>
			        <th style="padding: 10px; border: 1px solid #ddd;">First Name</th>
			        <th style="padding: 10px; border: 1px solid #ddd;">Middle Name</th>
			        <th style="padding: 10px; border: 1px solid #ddd;">Last Name</th>
			        <th style="padding: 10px; border: 1px solid #ddd;">Advisor</th>
			    </tr>
			<%
			rs = stmt.executeQuery(
			    "SELECT c.st_ID AS st_ID, s.st_firstName AS f, s.st_middleName AS m, s.st_lastName AS l, c.advisor AS advisor \n" +
			    "FROM Candidate c, Student s \n" +
			    "WHERE c.st_ID = s.st_ID \n" +
			    "ORDER BY s.st_firstName, s.st_middleName, s.st_lastName, c.st_ID"
			);
			
			while (rs.next()) {
			%>
			    <tr>
			        <form action="03_StudentEntry.jsp" method="get">
			            <input type="hidden" value="update_candidate" name="action">
			            <input type="hidden" name="st_ID" value="<%= rs.getString("st_ID") %>">
			            <td style="padding: 10px; border: 1px solid #ddd;"><%= rs.getString("st_ID") %></td>
			            <td style="padding: 10px; border: 1px solid #ddd;"><%= rs.getString("f") %></td>
			            <td style="padding: 10px; border: 1px solid #ddd;"><%= rs.getString("m") %></td>
			            <td style="padding: 10px; border: 1px solid #ddd;"><%= rs.getString("l") %></td>
			            <td style="padding: 10px; border: 1px solid #ddd;"><input value="<%= rs.getString("advisor") %>" name="advisor"></td>
			            <td style="padding: 10px; border: 1px solid #ddd;"><input type="submit" value="Update"></td>
			        </form>
			        <td><button onclick="window.location.href='./07_ThesisCommitteeEntry.jsp?sID=<%= rs.getString("st_ID") %>'">Thesis Committee Submission</button></td>
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
			
			<%
			/* experiment queries */
			
			/* 			
			CREATE TABLE Student (
			    st_ID VARCHAR(255) PRIMARY KEY,
			    st_SSN VARCHAR(255) UNIQUE NOT NULL,
			    st_enrollmentStatus VARCHAR(255) NOT NULL,
			    st_residential VARCHAR(255) NOT NULL,
			    st_firstName VARCHAR(255) NOT NULL,
			    st_middleName VARCHAR(255),
			    st_lastName VARCHAR(255) NOT NULL,
			    academic_status VARCHAR(255) NOT NULL
			);
			
			CREATE TABLE Undergraduate (
		        st_ID VARCHAR(255) PRIMARY KEY NOT NULL,
		        major VARCHAR(255) NOT NULL,
		        minor VARCHAR(255),
		        CONSTRAINT fk_u_st FOREIGN KEY (st_ID) REFERENCES Student(st_ID)
	        );
			
			CREATE TABLE Master (
		        st_ID VARCHAR(255) PRIMARY KEY NOT NULL,
		        department VARCHAR(255) NOT NULL,
		        CONSTRAINT fk_m_st FOREIGN KEY (st_ID) REFERENCES Student(st_ID)
	        );
			
			CREATE TABLE Precandidate (
		        st_ID VARCHAR(255) PRIMARY KEY NOT NULL,
		        CONSTRAINT fk_pc_st FOREIGN KEY (st_ID) REFERENCES Student(st_ID)
	        );
			
			CREATE TABLE Candidate (
		        st_ID VARCHAR(255) PRIMARY KEY NOT NULL,
		        advisor VARCHAR(255) NOT NULL, 
		        CONSTRAINT fk_c_st FOREIGN KEY (st_ID) REFERENCES Student(st_ID)
	        );
			
			
			*/
			%>
			
			
			<a href="./00_index.jsp">Back to Home Page</a>
			

</body>
</html>

