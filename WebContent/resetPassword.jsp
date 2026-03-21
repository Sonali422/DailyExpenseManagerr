<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp" />

<%
    String email = request.getParameter("email");
    if (email == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<div class="auth-container">
    <div class="glass-card">
        <h2>Reset Password</h2>
        <p class="form-subheader" style="text-align: center; color: #94a3b8; margin-bottom: 2rem;">Resetting password for: <strong><%= email %></strong></p>
        
        <form action="resetPassword" method="post" id="resetForm" onsubmit="return validateReset()">
            <input type="hidden" name="email" value="<%= email %>">
            
            <div class="form-group">
                <label>New Password</label>
                <div class="input-with-icon">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" id="password" required placeholder="Min 6 characters">
                </div>
            </div>
            
            <div class="form-group">
                <label>Confirm New Password</label>
                <div class="input-with-icon">
                    <i class="fas fa-shield-alt"></i>
                    <input type="password" name="confirmPassword" id="confirmPassword" required placeholder="Repeat your new password">
                </div>
                <span id="matchError" style="display:none; color:#fca5a5; font-size:0.8rem; margin-top:0.5rem;"><i class="fas fa-exclamation-circle"></i> Passwords do not match.</span>
            </div>
            
            <button type="submit" class="btn" id="resetBtn">Update Password</button>
        </form>
    </div>
</div>

<script>
function validateReset() {
    const p1 = document.getElementById('password').value;
    const p2 = document.getElementById('confirmPassword').value;
    const btn = document.getElementById('resetBtn');
    
    if (p1 !== p2) {
        document.getElementById('matchError').style.display = 'block';
        return false;
    }
    
    btn.classList.add('spinner-btn');
    btn.style.pointerEvents = 'none';
    return true;
}
</script>

<jsp:include page="footer.jsp" />
