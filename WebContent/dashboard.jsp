<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    double salary = 0.0;
    double totalExpenses = 0.0;
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps1 = con.prepareStatement("SELECT salary FROM users WHERE id=?");
         PreparedStatement ps2 = con.prepareStatement("SELECT SUM(amount) as t FROM expenses WHERE user_id=?")) {
         ps1.setInt(1, (int)session.getAttribute("userId"));
         try(ResultSet rs1 = ps1.executeQuery()) { if(rs1.next()) salary = rs1.getDouble("salary"); }
         
         ps2.setInt(1, (int)session.getAttribute("userId"));
         try(ResultSet rs2 = ps2.executeQuery()) { if(rs2.next()) totalExpenses = rs2.getDouble("t"); }
         
         // Fix: Only show current month expenses on dashboard to match "Monthly Limit"
         try (PreparedStatement ps3 = con.prepareStatement("SELECT SUM(amount) as t FROM expenses WHERE user_id=? AND strftime('%Y-%m', expense_date) = strftime('%Y-%m', 'now')")) {
             ps3.setInt(1, (int)session.getAttribute("userId"));
             try(ResultSet rs3 = ps3.executeQuery()) { if(rs3.next()) totalExpenses = rs3.getDouble("t"); }
         }
    } catch(Exception ignored) {}
%>
<jsp:include page="header.jsp" />

<% if (salary > 0 && totalExpenses > salary) { %>
    <script>
        window.onload = function() {
            const spent = parseFloat("<%= totalExpenses %>");
            const limit = parseFloat("<%= salary %>");
            if (spent > limit) {
                alert("⚠️ WARNING: You have exceeded your spending limit!\n\nTotal Spent: ₹" + spent.toFixed(2) + "\nMonthly Limit: ₹" + limit.toFixed(2) + "\n\nPlease manage your expenses carefully.");
            }
        };
    </script>
<% } %>

<div class="dashboard-container">
    <!-- Hero Banner (Emerald & Slate) -->
    <div class="hero-banner">
        <div class="hero-content">
            <h1 style="font-size: 2.5rem; margin-bottom: 1rem; color: #fff; letter-spacing: -0.05em;">Master Your Finances</h1>
            <p style="color: #cbd5e1; font-size: 1.1rem; line-height: 1.6;">Track every penny, visualize your spending, and reach your saving goals with ease. Your financial clarity starts here.</p>
        </div>
        <div class="hero-image" style="background: linear-gradient(135deg, rgba(16, 185, 129, 0.4), var(--secondary)); display: flex; align-items: center; justify-content: center;">
             <i class="fas fa-gem" style="font-size: 8rem; color: rgba(16, 185, 129, 0.2); filter: drop-shadow(0 0 20px rgba(16, 185, 129, 0.3));"></i>
        </div>
    </div>

    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 2rem;">
        <!-- Salary Section Card -->
        <div class="glass-card">
            <h3 style="display:flex; align-items:center; gap:0.75rem;"><i class="fas fa-wallet" style="color:#10b981;"></i> Monthly Limit</h3>
            <p style="color: #94a3b8; margin: 1rem 0;">Define your monthly spending capacity to stay on track.</p>
            <div style="background: rgba(15,23,42,0.4); border-radius:1rem; padding:1.5rem; text-align:center; margin-bottom:1.5rem;">
                <p style="color:#94a3b8; margin-bottom:0.5rem; font-size: 0.9rem;">Your Monthly Target</p>
                <h3 style="font-size: 2rem; color: #10b981;">₹<%= String.format("%.2f", salary) %></h3>
            </div>
            <form action="updateSalary" method="post">
                <div style="display:flex; gap:0.75rem; align-items:center;">
                    <div class="input-with-icon" style="flex: 1;">
                        <i class="fas fa-indian-rupee-sign"></i>
                        <input type="number" name="salary" step="0.01" required placeholder="New Limit" style="background: rgba(0,0,0,0.2);">
                    </div>
                    <button type="submit" class="btn" style="width: auto; padding: 0.875rem 1.5rem;"><i class="fas fa-sync-alt"></i></button>
                </div>
            </form>
        </div>

        <!-- Quick Actions Card -->
        <div class="glass-card">
            <h3 style="display:flex; align-items:center; gap:0.75rem;"><i class="fas fa-bolt" style="color:#f59e0b;"></i> Action Shortcuts</h3>
            <p style="color: #94a3b8; margin: 1rem 0;">Jump straight into managing your money.</p>
            <div style="display: flex; flex-direction: column; gap: 1rem; margin-top: 1rem;">
                <a href="addExpense.jsp" class="btn" style="background: rgba(16, 185, 129, 0.1); border: 1px solid rgba(16, 185, 129, 0.2); color: #34d399;">
                    <i class="fas fa-plus-circle" style="margin-right:0.5rem;"></i> Log New Expense
                </a>
                <a href="viewExpenses" class="btn" style="background: rgba(59, 130, 246, 0.1); border: 1px solid rgba(59, 130, 246, 0.2); color: #60a5fa;">
                    <i class="fas fa-history" style="margin-right:0.5rem;"></i> View History
                </a>
                <a href="monthlySummary" class="btn" style="background: rgba(245, 158, 11, 0.1); border: 1px solid rgba(245, 158, 11, 0.2); color: #fbbf24;">
                    <i class="fas fa-chart-pie" style="margin-right:0.5rem;"></i> Detailed Summary
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
