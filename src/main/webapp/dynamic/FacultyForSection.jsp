<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String cn = request.getParameter("courseName");
String title = request.getParameter("classTitle");
String year = request.getParameter("classYear");
String quarter = request.getParameter("classQuarter");
String section = request.getParameter("sectionID");
%>
<title>Faculty for <%= cn + " " + title + " " + quarter + year + " section " + section %></title>
</head>
<body>

<%-- Set the scripting language Java and --%>
		<%@ page language="java" import="java.sql.*" %>
		<h3>Faculty for <u><%= cn + " " + title + " " + quarter + year + " section " + section %></u></h3>
		<table>
				<tr>
					<th>Faculty Entry</th>
				</tr>
				<%
				try {
				    // Load driver
				    DriverManager.registerDriver(new org.postgresql.Driver());
				    
				    // Make a connection to the Oracle datasource
				    Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlink?user=postgres&password=helloworld");
				%>
			
				<% String sID; %>
				<!-- Insertion stuff? -->
				<%
					// Check if an insertion is required
					String action = request.getParameter("action");
					if (action != null && action.equals("insert")) {
					    
					    connection.setAutoCommit(false);
					   
					    sID = request.getParameter("s_sectionID");
						String[] faculty = request.getParameterValues("faculties");
                        if (faculty != null) {
	                        PreparedStatement pstmt = connection.prepareStatement(
	                            "INSERT INTO Teaches VALUES (?, ?)");
	                        for(String f : faculty) {
		                        pstmt.setString(1, sID);
		                        pstmt.setString(2, f);
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
				        "DELETE FROM Teaches WHERE s_sectionID = ? AND fc_name = ?"
				    );
				    
				    pstmt.setString(1, request.getParameter("s_sectionID"));
				    pstmt.setString(2, request.getParameter("fc_name"));
				    int rowCount = pstmt.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
					
				<%
					Statement stmt = connection.createStatement();
					ResultSet rs;
					
					String GET_Faculty_QUERY = "SELECT * FROM Faculty";
					rs = stmt.executeQuery(GET_Faculty_QUERY);
				%>
				<tr>
					<form action="FacultyForSection.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<input type="hidden" value="<%= section %>" name="s_sectionID">
						<td><select multiple name="faculties">
                            <option disabled>Select Faculty Member(s)</option>
                            <%
                            while (rs.next()) {
                                String fc_name = rs.getString("fc_name");
                                %>
                                <option value="<%=rs.getString("fc_name")%>"><%= fc_name %></option>
                                <%
                            } %>
                       	</select></td>
                       	<input type="hidden" name="courseName" value="<%= cn %>">
						<input type="hidden" name="classTitle" value="<%= title %>">
						<input type="hidden" name="classYear" value="<%= year %>">
						<input type="hidden" name="classQuarter" value="<%= quarter %>">
						<input type="hidden" name="sectionID" value="<%= section %>">
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
					

				<!-- Iteration stuff? -->
				<%
				rs = stmt.executeQuery(
			    	"SELECT fc_name FROM Teaches WHERE s_sectionID = '" + section + "' ORDER BY fc_name"
		        );
				
				while (rs.next()) {
				%>
				<tr>
					<td><%= rs.getString("fc_name") %></td>
					<form action="FacultyForSection.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= section %>" name="s_sectionID">
						<input type="hidden" value="<%= rs.getString("fc_name") %>" name="fc_name">
						<input type="hidden" name="courseName" value="<%= cn %>">
						<input type="hidden" name="classTitle" value="<%= title %>">
						<input type="hidden" name="classYear" value="<%= year %>">
						<input type="hidden" name="classQuarter" value="<%= quarter %>">
						<input type="hidden" name="sectionID" value="<%= section %>">
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
			/* experiment queries */
			
			/*
			
			*/
			%>
			
			<p></p>
			<br>
			<a href="./SectionsForClass.jsp?courseName=<%= cn %>&classTitle=<%= title %>&classYear=<%= year %>&classQuarter=<%= quarter %>">Back</a>
			<br>
			<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>