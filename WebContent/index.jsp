<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp" />

<div class="auth-container">
    <div class="glass-card">
        <div class="page-illustration">
            <img src="images/emerald_login_illustration_1774089110992.png" alt="Login Illustration">
        </div>
        <h2>Welcome Back</h2>
        <form action="login" method="post" id="loginForm" onsubmit="this.querySelector('.btn').classList.add('spinner-btn')">
            <div class="form-group">
                <label>Email Address</label>
                <div class="input-with-icon">
                    <i class="fas fa-envelope"></i>
                    <input type="email" name="email" required placeholder="Enter your email" autofocus>
                </div>
            </div>
            <div class="form-group" style="position: relative;">
                <label style="display:flex; justify-content:space-between;">Password
                    <a href="forgotPassword.jsp" style="color:#10b981; text-decoration:none; font-size:0.8rem; font-weight:normal;">Forgot Password?</a>
                </label>
                <div class="input-with-icon">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" id="password" required placeholder="Enter your password" style="padding-right: 2.5rem;">
                </div>
                <span id="togglePassword" style="position: absolute; right: 12px; top: 38px; cursor: pointer; color: #94a3b8; font-size:1.2rem;">👁</span>
            </div>
            <button type="submit" class="btn">Login Securely</button>
        </form>
        
        <script>
            document.getElementById('togglePassword').addEventListener('click', function (e) {
                const pwd = document.getElementById('password');
                if (pwd.type === 'password') {
                    pwd.type = 'text';
                    this.textContent = '🙈';
                } else {
                    pwd.type = 'password';
                    this.textContent = '👁';
                }
            });

            function validateLogin() {
                let valid = true;
                const email = document.getElementById('email').value;
                const pwd = document.getElementById('password').value;
                const btn = document.getElementById('loginBtn');
                
                if (!email || !/^\S+@\S+\.\S+$/.test(email)) {
                    document.getElementById('emailError').style.display = 'block';
                    valid = false;
                } else { document.getElementById('emailError').style.display = 'none'; }
                
                if (!pwd) {
                    document.getElementById('pwdError').style.display = 'block';
                    valid = false;
                } else { document.getElementById('pwdError').style.display = 'none'; }
                
                if (valid) {
                    btn.classList.add('spinner-btn');
                    btn.style.pointerEvents = 'none';
                }
                return valid;
            }
        </script>
        <div class="form-footer">
            Don't have an account? <a href="register.jsp">Create one here</a>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
