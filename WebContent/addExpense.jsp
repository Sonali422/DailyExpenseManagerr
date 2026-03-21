<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<jsp:include page="header.jsp" />

<div class="dashboard-container" style="max-width: 600px;">
    <div class="glass-card">
        <div class="page-illustration">
            <img src="images/add_expense_illustration_1774088891401.png" alt="Add Expense Illustration">
        </div>
        <h2>Log New Expense</h2>
        <form action="addExpense" method="post" onsubmit="this.querySelector('.btn').classList.add('spinner-btn')">
            <div class="form-group">
                <label>Expense Title</label>
                <div class="input-with-icon">
                    <i class="fas fa-tag"></i>
                    <input type="text" name="title" required placeholder="Lunch, Groceries, etc." autofocus>
                </div>
            </div>
            <div class="form-group">
                <label>Amount (₹)</label>
                <div class="input-with-icon">
                    <i class="fas fa-indian-rupee-sign"></i>
                    <input type="number" name="amount" required step="0.01" min="0" placeholder="0.00">
                </div>
            </div>
            <div class="form-group">
                <label>Category</label>
                <div class="input-with-icon">
                    <i class="fas fa-list"></i>
                    <select name="category" required>
                        <option value="Food">Food</option>
                        <option value="Transport">Transport</option>
                        <option value="Shopping">Shopping</option>
                        <option value="Utilities">Utilities</option>
                        <option value="Entertainment">Entertainment</option>
                        <option value="Others">Others</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label>Date</label>
                <div class="input-with-icon">
                    <i class="fas fa-calendar-alt"></i>
                    <input type="date" name="expense_date" id="expenseDate" required>
                </div>
            </div>
            <button type="submit" class="btn">Add to List</button>
        </form>
        
        <script>
            document.addEventListener("DOMContentLoaded", () => {
                // Set default date to today
                document.getElementById('expenseDate').valueAsDate = new Date();
            });
        </script>
    </div>
</div>

<jsp:include page="footer.jsp" />
