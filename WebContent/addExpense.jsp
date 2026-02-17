<%@ page session="true" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Expense</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <h2>Add New Expense</h2>
    <form action="addExpense" method="post">
        <label>Title:</label>
        <input type="text" name="title" required><br>

        <label>Amount:</label>
        <input type="number" name="amount" step="0.01" required><br>

        <input type="submit" value="Add Expense">
    </form>

    <p><a href="viewExpenses">View All Expenses</a> | <a href="monthlySummary">Monthly Summary</a> | <a href="logout">Logout</a></p>
</body>
</html>
