<%@ page import="java.util.List" %>
<%@ page import="models.Expense" %>
<%@ page session="true" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    List<Expense> expenses = (List<Expense>) request.getAttribute("expenses");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Your Expenses</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <h2>Expense List</h2>
    <table border="1">
        <tr>
            <th>Title</th>
            <th>Amount</th>
        </tr>
        <%
            if (expenses != null) {
                for (Expense exp : expenses) {
        %>
        <tr>
            <td><%= exp.getTitle() %></td>
            <td><%= exp.getAmount() %></td>
        </tr>
        <% } } else { %>
        <tr><td colspan="2">No expenses found.</td></tr>
        <% } %>
    </table>

    <p><a href="addExpense.jsp">Add New Expense</a> | <a href="monthlySummary">Monthly Summary</a> | <a href="logout">Logout</a></p>
</body>
</html>
