<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Degree Reqs</title>
</head>
<body>

<%-- Set the scripting language Java and --%>
		<%@ page language="java" import="java.sql.*" %>
		<h3>Degree Requirements</u></h3>
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
                        	"INSERT INTO Degree VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
						);
                        pstmt.setString(1, request.getParameter("majorCode"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("total")));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("lower")));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("upper")));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("elective")));
                        pstmt.setInt(6, Integer.parseInt(request.getParameter("technical")));
                        pstmt.setDouble(7, Double.parseDouble(request.getParameter("min_gpa")));
                        pstmt.setString(8, request.getParameter("type"));
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
				        "UPDATE Degree SET total = ?, lower = ?, upper = ?, elective = ?, technical = ?, min_gpa = ?, type = ? \n"+
				    	"WHERE majorCode = ?"
				    );
				    
				    pstmt.setInt(1, Integer.parseInt(request.getParameter("total")));
				    pstmt.setInt(2, Integer.parseInt(request.getParameter("lower")));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("upper")));
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("elective")));
                    pstmt.setInt(5, Integer.parseInt(request.getParameter("technical")));
                    pstmt.setDouble(6, Double.parseDouble(request.getParameter("min_gpa")));
                    pstmt.setString(7, request.getParameter("type"));
				    pstmt.setString(8, request.getParameter("majorCode"));
				    
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
			            "DELETE FROM Degree WHERE majorCode = ?"
				    );
				    
				    pstmt.setString(1, request.getParameter("majorCode"));
				    int rowCount = pstmt.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
					
				<%
					Statement stmt = connection.createStatement();
					ResultSet rs;
				%>
				<tr>
					<th>Major Code</th>
					<th>Total Units</th>
					<th>Lower Div Units</th>
					<th>Upper Div Units</th>
					<th>Elective Units</th>
					<th>Tech. Elective Units</th>
					<th>Minimum GPA</th>
					<th>Type</th>
				</tr>
				<tr>
					<form action="10_DegreeRequirementsEntry.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<td><input value="" name="majorCode"></td>
						<td><input value="" name="total"></td>
						<td><input value="" name="lower"></td>
						<td><input value="" name="upper"></td>
						<td><input value="" name="elective"></td>
						<td><input value="" name="technical"></td>
						<td><input value="" name="min_gpa"></td>
						<td><input value="" name="type"></td>
						<td><input type="submit" value="Insert"></td>
					</form>
				</tr>
					

				<!-- Iteration stuff? -->
				<%
				rs = stmt.executeQuery(
			    	"SELECT * FROM Degree"
		        );
				
				while (rs.next()) {
				%>
				<tr>
					<form action="10_DegreeRequirementsEntry.jsp" method="get">
						<input type="hidden" value="update" name="action">
						<td><input value="<%= rs.getString("majorCode") %>" name="majorCode"></td>
						<td><input value="<%= rs.getInt("total") %>" name="total"></td>
						<td><input value="<%= rs.getInt("lower") %>" name="lower"></td>
						<td><input value="<%= rs.getInt("upper") %>" name="upper"></td>
						<td><input value="<%= rs.getInt("elective") %>" name="elective"></td>
						<td><input value="<%= rs.getInt("technical") %>" name="technical"></td>
						<td><input value="<%= rs.getDouble("min_gpa") %>" name="min_gpa"></td>
						<td><input value="<%= rs.getString("type") %>" name="type"></td>
						<td><input type="submit" value="Update"></td>
					</form>
					<form action="10_DegreeRequirementsEntry.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= rs.getString("majorCode") %>" name="majorCode">
						<td><input type="submit" value="Delete"></td>
					</form>
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
			
			
			
			*/
			
			%>
			
			<p></p>
			<br>
			<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>