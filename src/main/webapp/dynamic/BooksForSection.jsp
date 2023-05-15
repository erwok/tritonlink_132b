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
<title>Books for <%= cn + " " + title + " " + quarter + year + " section " + section %></title>
</head>
<body>
<%-- Set the scripting language Java and --%>
		<%@ page language="java" import="java.sql.*" %>
		<h3>Books for <u><%= cn + " " + title + " " + quarter + year + " section " + section %></u></h3>
		<table>
				<tr>
					<th>ISBN</th>
					<th>Title</th>
					<th>Edition</th>
					<th>Publisher</th>
					<th>Au. FName</th>
					<th>Au. LName</th>
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
					    // INSERT the Faculty attrs INTO the Faculty table
					    PreparedStatement pstmt = connection.prepareStatement(
					    ("INSERT INTO Booklist VALUES (?, ?, ?, ?, ?, ?, ?)"));
					    
					    pstmt.setInt(1, Integer.parseInt(request.getParameter("isbn")));
					    pstmt.setString(2, request.getParameter("title"));
					    pstmt.setInt(3, Integer.parseInt(request.getParameter("edition")));
					    pstmt.setString(4, request.getParameter("publisher"));
					    pstmt.setString(5, request.getParameter("author_fname"));
					    pstmt.setString(6, request.getParameter("author_lname"));
					    pstmt.setString(7, request.getParameter("s_sectionID"));
					    
					    pstmt.executeUpdate();
					    
					    connection.commit();
					    connection.setAutoCommit(true);
					}
				
				%>
				
				<!-- Update stuff? -->
				<%
				// Check if an update is requested
				if (action != null && action.equals("update")) {
				    
				    connection.setAutoCommit(false);
				    
				    PreparedStatement pstatement = connection.prepareStatement(
				    	"UPDATE Booklist SET title = ?, edition = ?, publisher = ?, \n" +
				    	"author_fname = ?, author_lname = ?\n" +
				    	"WHERE isbn = ?"
				    );

				    pstatement.setString(1, request.getParameter("title"));
				    pstatement.setInt(2, Integer.parseInt(request.getParameter("edition")));
				    pstatement.setString(3, request.getParameter("publisher"));
				    pstatement.setString(4, request.getParameter("author_fname"));
				    pstatement.setString(5, request.getParameter("author_lname"));
				    pstatement.setInt(6, Integer.parseInt(request.getParameter("isbn")));
				    int rowCount = pstatement.executeUpdate();
				    
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
				        "DELETE FROM Booklist WHERE isbn = ?"
				    );
				    
				    pstmt.setInt(1, Integer.parseInt(request.getParameter("isbn")));
				    int rowCount = pstmt.executeUpdate();
				    
				    connection.setAutoCommit(false);
				    connection.setAutoCommit(true);
				}
				%>
				
					
				<%
					Statement stmt = connection.createStatement();
					ResultSet rs;
					
					String GET_BooksForSection_QUERY = "SELECT * FROM Booklist WHERE s_sectionID = '" + section + "'";
					rs = stmt.executeQuery(GET_BooksForSection_QUERY);
				%>
				<tr>
					<form action="BooksForSection.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<input type="hidden" value="<%= section %>" name="s_sectionID">
						<th><input value="" name="isbn" size="10"></th>
						<th><input value="" name="title" size="10"></th>
						<th><input value="" name="edition" size="10"></th>
						<th><input value="" name="publisher" size="10"></th>
						<th><input value="" name="author_fname" size="10"></th>
						<th><input value="" name="author_lname" size="10"></th>
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
				    "SELECT * FROM Booklist WHERE s_sectionID = '" + section + "'"
		        );
				
				while (rs.next()) {
				%>
				<tr>
					<form action="BooksForSection.jsp" method="get">
						<input type="hidden" value="update" name="action">
						<td><input value="<%= rs.getInt("isbn") %>" name="isbn"></td>
						<td><input value="<%= rs.getString("title") %>" name="title"></td>
						<td><input value="<%= rs.getInt("edition") %>" name="edition"></td>
						<td><input value="<%= rs.getString("publisher") %>" name="publisher"></td>
						<td><input value="<%= rs.getString("author_fname") %>" name="author_fname"></td>
						<td><input value="<%= rs.getString("author_lname") %>" name="author_lname"></td>
						<input type="hidden" name="courseName" value="<%= cn %>">
						<input type="hidden" name="classTitle" value="<%= title %>">
						<input type="hidden" name="classYear" value="<%= year %>">
						<input type="hidden" name="classQuarter" value="<%= quarter %>">
						<input type="hidden" name="sectionID" value="<%= section %>">
						<td><input type="submit" value="Update"></td>
					</form>
					<form action="BooksForSection.jsp" method="get">
						<input type="hidden" value="delete" name="action">
						<input type="hidden" value="<%= rs.getString("isbn") %>" name="isbn">
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
			
			
			<p></p>
			<br>
			<a href="./SectionsForClass.jsp?courseName=<%= cn %>&classTitle=<%= title %>&classYear=<%= year %>&classQuarter=<%= quarter %>">Back</a>
			<br>
			<a href="./00_index.jsp">Back to Home Page</a>


</body>
</html>