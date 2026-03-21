<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp" />

<div class="auth-container">
    <div class="glass-card">
        <h2>Create Account</h2>
        <form action="register" method="post" onsubmit="this.querySelector('.btn').classList.add('spinner-btn')">
            <div class="form-group">
                <label>Full Name</label>
                <div class="input-with-icon">
                    <i class="fas fa-user"></i>
                    <input type="text" name="name" required placeholder="John Doe" autofocus>
                </div>
            </div>
            <div class="form-group">
                <label>Email Address</label>
                <div class="input-with-icon">
                    <i class="fas fa-envelope"></i>
                    <input type="email" name="email" required placeholder="name@example.com">
                </div>
            </div>
            <div class="form-group">
                <label>Password</label>
                <div class="input-with-icon">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" required placeholder="Create a strong password">
                </div>
            </div>
            <button type="submit" class="btn">Register Account</button>
        </form>
        <div class="form-footer">
            Already have an account? <a href="index.jsp">Login here</a>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
