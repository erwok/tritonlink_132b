<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String majorCode = request.getParameter("majorCode");
%>
<title>Select Concentrations for MS Degree <%= majorCode %></title>
</head>
<body>

<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<table>
				<tr>
					<th>Degree Concentrations Entry</th>
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
					   
					    // Handle inserting prereqs into db
						String[] concentrations = request.getParameterValues("concentrations");
                        if (concentrations != null) {
	                        PreparedStatement pstmt = connection.prepareStatement(
	                            "INSERT INTO DegreeConcentrations VALUES (?, ?)");
	                        for(String c : concentrations) {
	                            pstmt.setString(1, majorCode);
	                            pstmt.setString(2, c);
		                        pstmt.executeUpdate();
	                        }
	                        
	                        connection.commit();
                        }
                        
                        connection.setAutoCommit(true);
					}
				
				%>
				
				<!-- Delete stuff? -->
				<%
				// Check if a delete is requested
				if (action != null && action.equals("delete")) {
				    
				    connection.setAutoCommit(false);
				    
				    PreparedStatement pstmt = connection.prepareStatement(
				    	"DELETE FROM DegreeConcentrations WHERE majorCode = ? AND concentrationName = ?"
					);
				    
				    pstmt.setString(1, majorCode);
				    pstmt.setString(2, request.getParameter("concentrationName"));
					pstmt.executeUpdate();
				    
				    connection.commit();
				    
				    connection.setAutoCommit(true);
				}
				%>
				
					
				<%
					Statement stmt = connection.createStatement();
				
					String GET_Course_QUERY = "SELECT * FROM Concentration";
					ResultSet rs = stmt.executeQuery(GET_Course_QUERY);
				%>
				
				<tr>
					<form action="22_DegreeConcentrationSelection.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<input type="hidden" value="<%= majorCode %>" name="majorCode">
						<td><select multiple name="concentrations">
                            <option disabled>Select concentration(s)</option>
                            <%
                            while (rs.next()) {
                                String concentrationName = rs.getString("name");
                                %>
                                <option value="<%= concentrationName %>"><%= concentrationName %></option>
                                <%
                            } %>
                       	</select></td>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				
				
				<tr><td><h3>Concentrations under Degree <%= majorCode %></h3></td></tr>
				
				<%
					String GET_Degree_Concentrations_Query = String.format("SELECT * FROM DegreeConcentrations WHERE majorCode = '%s';", majorCode);
					rs = stmt.executeQuery(GET_Degree_Concentrations_Query);
				
					while (rs.next()) {
				%>
				<tr>
 					<td><%= rs.getString("concentrationName") %></td>
					<form action="22_DegreeConcentrationSelection.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= majorCode %>" name="majorCode">
						<input type="hidden" value="<%= rs.getString("concentrationName") %>" name="concentrationName">
						<td><input type="submit" value="Delete"></td>
					</form>
				</tr>
				<%
					}
				%>
				
				<%
				// Close the ResultSet
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
			</table>
			
			<p></p>
			<br>
			<a href="./10_DegreeRequirementsEntry.jsp">Back to Degree Requirements Entry page</a>
			<br>
			<a href="./00_index.jsp">Back to Home Page</a>


</body>
</html>