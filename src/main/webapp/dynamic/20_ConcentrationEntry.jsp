<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Concentration Entry</title>
</head>
<body>

<%-- Set the scripting language Java and --%>
		<%@ page language="java" import="java.sql.*" %>
		<h3>Concentration Entry Form</u></h3>
		<table>
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
					   
                        PreparedStatement pstmt = connection.prepareStatement(
                        	"INSERT INTO Concentration VALUES (?, ?, ?)"
						);
                        pstmt.setString(1, request.getParameter("name"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("min_units")));
                        pstmt.setDouble(3, Double.parseDouble(request.getParameter("min_gpa")));
                        pstmt.executeUpdate();
                        
                        connection.setAutoCommit(true);
					}
				%>
				
				<!-- Update stuff? -->
				<%
				// Check if an update is requested
				if (action != null && action.equals("update")) {
				    
				    connection.setAutoCommit(false);
				    
				    PreparedStatement pstmt = connection.prepareStatement(
				        "UPDATE Concentration SET min_units = ?, min_gpa = ? \n"+
				    	"WHERE name = ?"
				    );
				    
				    pstmt.setInt(1, Integer.parseInt(request.getParameter("min_units")));
                    pstmt.setDouble(2, Double.parseDouble(request.getParameter("min_gpa")));
				    pstmt.setString(3, request.getParameter("name"));
				    
				    pstmt.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
				<!-- Delete stuff? -->
				<%
				// Check if a delete is requested
				if (action != null && action.equals("delete")) {
				    
				    connection.setAutoCommit(false);
				    
				    PreparedStatement pstmt = connection.prepareStatement(
			            "DELETE FROM Concentration WHERE name = ?"
				    );
				    
				    pstmt.setString(1, request.getParameter("name"));
				    pstmt.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
					
				<%
					Statement stmt = connection.createStatement();
					ResultSet rs;
				%>
				<tr>
					<th>Concentration Name</th>
					<th>Min Units</th>
					<th>Min GPA</th>
				</tr>
				<tr>
					<form action="20_ConcentrationEntry.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<td><input value="" name="name"></td>
						<td><input value="" name="min_units"></td>
						<td><input value="" name="min_gpa"></td>
						<td><input type="submit" value="Insert"></td>
					</form>
				</tr>
					

				<!-- Iteration stuff? -->
				<%
				rs = stmt.executeQuery(
			    	"SELECT * FROM Concentration"
		        );
				
				while (rs.next()) {
				%>
				<tr>
					<form action="20_ConcentrationEntry.jsp" method="get">
						<input type="hidden" value="update" name="action">
						<td><input value="<%= rs.getString("name") %>" name="name"></td>
						<td><input value="<%= rs.getInt("min_units") %>" name="min_units"></td>
						<td><input value="<%= rs.getDouble("min_gpa") %>" name="min_gpa"></td>
						<td><input type="submit" value="Update"></td>
					</form>
					<form action="20_ConcentrationEntry.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= rs.getString("name") %>" name="name">
						<td><input type="submit" value="Delete"></td>
					</form>
					<td><button onclick="window.location.href='./21_ConcentrationCourseSelection.jsp?name=<%= rs.getString("name") %>'">Select Courses</button></td>
				</tr>
				<%
				}
				
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
			</table>
			
			<%
			/* Experiment queries */
			
			/*
			 
			
			CREATE TABLE Degree (
			    majorCode VARCHAR(255) PRIMARY KEY,
			    total INT NOT NULL,
			    lower INT,
			    upper INT,
			    elective INT,
			    technical INT,
			    min_gpa DECIMAL(2,1),
			    type VARCHAR(255)
			);
			
			CREATE TABLE Concentration (
		        name VARCHAR(255) PRIMARY KEY,
		        min_units INT NOT NULL,
		        min_gpa DECIMAL(2,1)
	        );
			
			CREATE TABLE ConcentrationCourses (
		        name VARCHAR(255) NOT NULL,
		        cr_courseNumber VARCHAR(255) NOT NULL,
		        CONSTRAINT fk_conCou_con FOREIGN KEY (name) REFERENCES Concentration(name) ON DELETE CASCADE,
		        CONSTRAINT fk_conCou_c FOREIGN KEY (cr_courseNumber) REFERENCES Course(cr_courseNumber) ON DELETE CASCADE
	        );
			
			
			*/
			
			%>
			
			<p></p>
			<br>
			<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>