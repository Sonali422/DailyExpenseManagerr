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
    <title>Monthly Summary</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="js/charts.js"></script>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <h2>Monthly Expense Summary</h2>
    <canvas id="summaryChart" width="400" height="200"></canvas>

    <script>
        // Example values - replace with real data from backend
        const labels = <%= request.getAttribute("months") %>;
        const data = <%= request.getAttribute("amounts") %>;

        drawBarChart("summaryChart", labels, data, "Monthly Expenses");
    </script>

    <p><a href="addExpense.jsp">Add Expense</a> | <a href="viewExpenses">View Expenses</a> | <a href="logout">Logout</a></p>
</body>
</html>
