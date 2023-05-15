<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String sID1 = request.getParameter("sID");
String tcID1 = request.getParameter("tcID");
%>
<title>Professors for Student <%= sID1 %>, Thesis Committee <%= tcID1 %></title>
</head>
<body>

<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			<table>
				<tr>
					<th>Professor Entry</th>
				</tr>
				<%
				try {
				    // Load driver
				    DriverManager.registerDriver(new org.postgresql.Driver());
				    
				    // Make a connection to the Oracle datasource
				    Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlink?user=postgres&password=helloworld");
				%>
				
				<% String sID2; %>
				<% String tcID2; %>
				
				<!-- Insertion stuff? -->
				<%
					// Check if an insertion is required
					String action = request.getParameter("action");
					if (action != null && action.equals("insert")) {
					    
					    connection.setAutoCommit(false);
					   	
					    tcID2 = request.getParameter("tc_ID");
						String[] faculty = request.getParameterValues("faculties");
                        if (faculty != null) {
	                        PreparedStatement pstmt = connection.prepareStatement(
	                            "INSERT INTO TCProfs VALUES (?, ?)");
	                        for(String f : faculty) {
		                        pstmt.setString(1, tcID2);
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
				        "DELETE FROM TCProfs WHERE tc_ID = ? AND fc_name = ?"
				    );
				    
				    pstmt.setString(1, request.getParameter("tc_ID"));
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
					<form action="18_TCProfessors.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<input type="hidden" value="<%= tcID1 %>" name="tc_ID">
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
                       	<input type="hidden" name="sID" value="<%= sID1 %>">
						<input type="hidden" name="tcID" value="<%= tcID1 %>">>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
					

				<!-- Iteration stuff? -->
				<%
				rs = stmt.executeQuery(
			    	"SELECT fc_name FROM TCProfs WHERE tc_ID = '" + tcID1 + "' ORDER BY fc_name"
		        );
				
				while (rs.next()) {
				%>
				<tr>
					<td><%= rs.getString("fc_name") %></td>
					<form action="18_TCProfessors.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= rs.getString("fc_name") %>" name="fc_name">
						<input type="hidden" name="sID" value="<%= sID1 %>">
						<input type="hidden" name="tcID" value="<%= tcID1 %>">
						<input type="hidden" value="<%= tcID1 %>" name="tc_ID">
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
			
			<p></p>
			<br>
			<a href="./07_ThesisCommitteeEntry.jsp?sId=<%= sID1 %>">Back Candidate</a>
			<br>
			<a href="./00_index.jsp">Back to Home Page</a>


</body>
</html>