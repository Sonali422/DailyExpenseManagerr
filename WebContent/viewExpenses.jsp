<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    List<Map<String, Object>> expenses = (List<Map<String, Object>>) request.getAttribute("expenses");
%>
<jsp:include page="header.jsp" />

<div class="dashboard-container">
    <div class="glass-card">
        <h2>Expense History</h2>
        
        <!-- Controls Section -->
        <div style="display: flex; flex-wrap: wrap; gap: 1rem; margin-bottom: 2rem; background: rgba(15, 23, 42, 0.3); padding: 1.5rem; border-radius: 1rem; border: 1px solid rgba(255,255,255,0.05); align-items: center;">
            <div style="flex: 2; min-width: 250px;">
                <div class="input-with-icon">
                    <i class="fas fa-search"></i>
                    <input type="text" id="searchInput" placeholder="Search by title..." onkeyup="filterExpenses()">
                </div>
            </div>
            <div style="flex: 1; min-width: 150px;">
                <div class="input-with-icon">
                    <i class="fas fa-filter"></i>
                    <select id="categoryFilter" onchange="filterExpenses()">
                        <option value="all">All Categories</option>
                        <option value="Food">Food</option>
                        <option value="Transport">Transport</option>
                        <option value="Shopping">Shopping</option>
                        <option value="Utilities">Utilities</option>
                        <option value="Entertainment">Entertainment</option>
                        <option value="Others">Others</option>
                    </select>
                </div>
            </div>
            <div style="flex: 1; min-width: 150px;">
                <div class="input-with-icon">
                    <i class="fas fa-calendar-alt"></i>
                    <input type="date" id="dateFromFilter" onchange="filterExpenses()">
                </div>
            </div>
            <span style="color: #94a3b8; align-self: center;">to</span>
            <div style="flex: 1; min-width: 150px;">
                <div class="input-with-icon">
                    <i class="fas fa-calendar-alt"></i>
                    <input type="date" id="dateToFilter" onchange="filterExpenses()">
                </div>
            </div>
            <div style="flex: 1; min-width: 150px;">
                <div class="input-with-icon">
                    <i class="fas fa-sort"></i>
                    <select id="sortOrder" onchange="filterExpenses()">
                        <option value="latest">Latest First</option>
                        <option value="oldest">Oldest First</option>
                        <option value="amountHigh">Amount (High to Low)</option>
                        <option value="amountLow">Amount (Low to High)</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="table-container">
            <table id="expensesTable">
                <thead>
                    <tr>
                        <th>Title</th>
                        <th>Amount</th>
                        <th>Category</th>
                        <th>Date</th>
                        <th style="min-width: 120px; text-align: center;">Actions</th>
                    </tr>
                </thead>
                <tbody id="expensesBody">
                    <% 
                    if (expenses != null && !expenses.isEmpty()) {
                        for (Map<String, Object> e : expenses) { 
                        String category = (String) e.get("category");
                        String iconClass = "fa-receipt";
                        if ("Food".equals(category)) iconClass = "fa-utensils";
                        else if ("Transport".equals(category)) iconClass = "fa-car";
                        else if ("Shopping".equals(category)) iconClass = "fa-shopping-bag";
                        else if ("Utilities".equals(category)) iconClass = "fa-plug";
                        else if ("Entertainment".equals(category)) iconClass = "fa-film";
                    %>
                    <tr class="expense-row" data-title="<%= ((String)e.get("title")).toLowerCase() %>" data-category="<%= category %>" data-date="<%= e.get("expense_date") %>" data-amount="<%= e.get("amount") %>">
                        <td data-label="Title"><i class="fas <%= iconClass %>" style="margin-right:0.75rem; color:#10b981;"></i> <%= e.get("title") %></td>
                        <td data-label="Amount" style="font-weight: 700; color: #10b981;">₹<%= String.format("%.2f", (Double)e.get("amount")) %></td>
                        <td data-label="Category"><span style="background: rgba(16, 185, 129, 0.1); color: #34d399; padding: 0.25rem 0.75rem; border-radius: 1rem; font-size: 0.85rem;"><%= category %></span></td>
                        <td data-label="Date" style="color: #94a3b8;"><%= e.get("expense_date") %></td>
                        <td data-label="Actions">
                            <div style="display: flex; gap: 0.5rem; justify-content: flex-end;">
                                <a href="addExpense.jsp?id=<%= e.get("id") %>" class="btn" style="padding: 0.4rem 0.8rem; font-size: 0.8rem; background: rgba(59, 130, 246, 0.2); color: #60a5fa; border: 1px solid rgba(59, 130, 246, 0.3);"><i class="fas fa-edit"></i></a>
                                <form action="deleteExpense" method="post" onsubmit="return confirm('Are you sure you want to delete this expense?')" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= e.get("id") %>">
                                    <button type="submit" class="btn" style="padding: 0.4rem 0.8rem; font-size: 0.8rem; background: rgba(239, 68, 68, 0.2); color: #f87171; border: 1px solid rgba(239, 68, 68, 0.3);"><i class="fas fa-trash"></i></button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                <% } else { %>
                    <tr>
                        <td colspan="5">
                            <div class="empty-state">
                                <img src="images/empty_state_illustration_1774088691054.png" alt="Empty State" style="width: 100%; max-width: 300px; margin-bottom: 2rem; opacity: 0.8; filter: drop-shadow(0 0 20px rgba(16, 185, 129, 0.2));">
                                <h3>No expenses recorded</h3>
                                <p>Start by adding your first expense to see your spending history here.</p>
                                <a href="addExpense.jsp" class="btn" style="width: auto; margin-top: 1.5rem; padding: 0.75rem 2rem;"><i class="fas fa-plus-circle"></i> Add My First Expense</a>
                            </div>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>

        <!-- Client-Side Empty State for Filters -->
        <div id="filterEmptyState" class="empty-state" style="display: none;">
            <i class="fas fa-search" style="font-size: 4rem; color: rgba(16, 185, 129, 0.2); margin-bottom: 2rem;"></i>
            <h3>No matches found</h3>
            <p>Try adjusting your search or filters to find what you're looking for.</p>
        </div>
    </div>
</div>

<script>
    function filterExpenses() {
        const searchInput = document.getElementById('searchInput');
        const catSelect = document.getElementById('categoryFilter');
        const dateFrom = document.getElementById('dateFromFilter');
        const dateTo = document.getElementById('dateToFilter');
        const sortSelect = document.getElementById('sortOrder');
        
        const query = searchInput.value.toLowerCase();
        const cat = catSelect.value;
        const df = dateFrom.value;
        const dt = dateTo.value;
        const sort = sortSelect.value;

        const rows = Array.from(document.querySelectorAll('.expense-row'));
        const tbody = document.getElementById('expensesBody');
        const filterEmptyState = document.getElementById('filterEmptyState');

        let visibleCount = 0;

        const filteredRows = rows.filter(row => {
            const title = row.getAttribute('data-title');
            const category = row.getAttribute('data-category');
            const date = row.getAttribute('data-date');

            let match = true;
            if (query && !title.includes(query)) match = false;
            if (cat !== 'all' && category !== cat) match = false;
            if (df && date < df) match = false;
            if (dt && date > dt) match = false;
            return match;
        });

        // Sorting
        filteredRows.sort((a, b) => {
            const da = a.getAttribute('data-date');
            const db = b.getAttribute('data-date');
            const aa = parseFloat(a.getAttribute('data-amount'));
            const ab = parseFloat(b.getAttribute('data-amount'));

            if (sort === 'latest') return da < db ? 1 : -1;
            if (sort === 'oldest') return da > db ? 1 : -1;
            if (sort === 'amountHigh') return ab - aa;
            if (sort === 'amountLow') return aa - ab;
            return 0;
        });

        // Re-append to tbody and control visibility
        rows.forEach(r => r.style.display = 'none');
        filteredRows.forEach(r => {
            tbody.appendChild(r); // Reordering
            r.style.display = '';
            visibleCount++;
        });

        // Handle empty state
        if (visibleCount === 0 && rows.length > 0) {
            filterEmptyState.style.display = 'block';
        } else {
            filterEmptyState.style.display = 'none';
        }
    }

    // Initial sort
    document.addEventListener("DOMContentLoaded", filterExpenses);
</script>
    </div>
</div>

<jsp:include page="footer.jsp" />
