<%@ page session="false" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Simple Daily Expense Manager</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <h2>Login</h2>
    <form action="login" method="post">
        <label>Username:</label>
        <input type="text" name="username" required><br>

        <label>Password:</label>
        <input type="password" name="password" required><br>

        <input type="submit" value="Login">
    </form>
    <p>Don't have an account? <a href="register.jsp">Register here</a>.</p>
</body>
</html>
