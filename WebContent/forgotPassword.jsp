<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp" />

<div class="auth-container">
    <div class="glass-card">
        <h2>Forgot Password</h2>
        <p class="form-subheader" style="text-align: center; color: #94a3b8; margin-bottom: 2rem;">Enter your email address to reset your password.</p>
        
        <form action="forgotPassword" method="post" onsubmit="this.querySelector('.btn').classList.add('spinner-btn')">
            <div class="form-group">
                <label>Email Address</label>
                <div class="input-with-icon">
                    <i class="fas fa-envelope"></i>
                    <input type="email" name="email" required placeholder="name@example.com" autofocus>
                </div>
            </div>
            <button type="submit" class="btn">Send Reset Link</button>
        </form>
        
        <div class="form-footer">
            Remembered your password? <a href="index.jsp">Back to Login</a>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
