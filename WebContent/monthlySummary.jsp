<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    Object totalObj = request.getAttribute("total");
    double total = totalObj != null ? (Double) totalObj : 0.00;
    
    int expenseCount = request.getAttribute("expenseCount") != null ? (Integer) request.getAttribute("expenseCount") : 0;
    double highestExpense = request.getAttribute("highestExpense") != null ? (Double) request.getAttribute("highestExpense") : 0.0;
    String monthFilter = (String) request.getAttribute("monthFilter");
    
    int sNeeds = request.getAttribute("splitNeeds") != null ? (Integer) request.getAttribute("splitNeeds") : 50;
    int sWants = request.getAttribute("splitWants") != null ? (Integer) request.getAttribute("splitWants") : 30;
    int sSavings = request.getAttribute("splitSavings") != null ? (Integer) request.getAttribute("splitSavings") : 20;

    String dateCondition = "";
    if ("current".equals(monthFilter)) {
         dateCondition = " AND strftime('%Y-%m', expense_date) = strftime('%Y-%m', 'now')";
    } else if ("last".equals(monthFilter)) {
         dateCondition = " AND strftime('%Y-%m', expense_date) = strftime('%Y-%m', 'now', '-1 month')";
    }
    
    double salary = 0.0;
    Map<String, Double> categoryData = new HashMap<>();

    try (Connection con = DBConnection.getConnection()) {
        try (PreparedStatement ps = con.prepareStatement("SELECT salary FROM users WHERE id=?")) {
             ps.setInt(1, (int)session.getAttribute("userId"));
             try(ResultSet rs = ps.executeQuery()) { if(rs.next()) salary = rs.getDouble("salary"); }
        }
        try (PreparedStatement ps2 = con.prepareStatement("SELECT category, SUM(amount) as cat_total FROM expenses WHERE user_id=?" + dateCondition + " GROUP BY category")) {
             ps2.setInt(1, (int)session.getAttribute("userId"));
             try(ResultSet rs2 = ps2.executeQuery()) { 
                 while(rs2.next()) {
                     categoryData.put(rs2.getString("category"), rs2.getDouble("cat_total"));
                 }
             }
        }
    } catch(Exception ignored) {}
    
    double needs = salary * (sNeeds / 100.0);
    double wants = salary * (sWants / 100.0);
    double savings = salary * (sSavings / 100.0);

    // Convert Map to JS array strings
    StringBuilder labels = new StringBuilder("[");
    StringBuilder data = new StringBuilder("[");
    int i = 0;
    for (Map.Entry<String, Double> entry : categoryData.entrySet()) {
        if (i > 0) {
            labels.append(",");
            data.append(",");
        }
        labels.append("'").append(entry.getKey()).append("'");
        data.append(entry.getValue());
        i++;
    }
    labels.append("]");
    data.append("]");
%>
<jsp:include page="header.jsp" />
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<div class="dashboard-container" style="max-width: 1200px;">
    <div class="glass-card">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
            <h2><i class="fas fa-chart-pie" style="color:#10b981; margin-right:0.75rem;"></i> Financial Insights</h2>
            <div class="input-with-icon" style="width: auto;">
                <i class="fas fa-calendar-check"></i>
                <select id="monthSelect" onchange="window.location.href='monthlySummary?month=' + this.value" style="padding-left: 2.5rem; width: auto;">
                    <option value="all" <%= "all".equals(monthFilter) ? "selected" : "" %>>All Time</option>
                    <option value="current" <%= "current".equals(monthFilter) ? "selected" : "" %>>This Month</option>
                    <option value="last" <%= "last".equals(monthFilter) ? "selected" : "" %>>Last Month</option>
                </select>
            </div>
        </div>
        
        <div style="display: flex; flex-wrap: wrap; gap: 2rem; margin-top: 1rem;">
            <!-- Left Side: Total and Limits -->
            <div style="flex: 1; min-width: 300px;">
                <div style="background: rgba(15,23,42,0.5); padding: 3rem; border-radius: 1.5rem; text-align:center;">
                    <p style="color: #94a3b8; margin-bottom: 1rem; font-size: 1.25rem;">Total Accumulated Spending</p>
                    <h1 class="count-up" data-target="<%= total %>" style="font-size: 3.5rem; font-weight: 800; background: linear-gradient(135deg, #f87171, #f43f5e); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;">
                        ₹0.00
                    </h1>
                    <div style="display: flex; gap: 1rem; justify-content: center; margin-top: 1.5rem;">
                        <div style="background: rgba(255,255,255,0.05); padding: 1rem; border-radius: 1rem;">
                            <p style="color:#94a3b8; font-size:0.85rem;">Total Expenses</p>
                            <h4 class="count-up-int" data-target="<%= expenseCount %>" style="font-size:1.5rem; color:#60a5fa;">0</h4>
                        </div>
                        <div style="background: rgba(255,255,255,0.05); padding: 1rem; border-radius: 1rem;">
                            <p style="color:#94a3b8; font-size:0.85rem;">Highest Expense</p>
                            <h4 class="count-up" data-target="<%= highestExpense %>" style="font-size:1.5rem; color:#f87171;">₹0.00</h4>
                        </div>
                    </div>
                </div>
                
                <% if (salary > 0) { %>
                <div style="margin-top: 2rem;">
                    <h3 style="text-align:center; margin-bottom:1.5rem; color:#cbd5e1;">Target Budget Split (<%= sNeeds %>/<%= sWants %>/<%= sSavings %>)</h3>
                    <div class="summary-cards" style="grid-template-columns: repeat(3, 1fr);">
                        <div class="summary-card" style="padding: 1rem; border-top: 4px solid #3b82f6;">
                            <h3 style="font-size: 0.9rem;">Needs (<%= sNeeds %>%)</h3>
                            <p style="font-size: 1.1rem; font-weight: bold; color: #60a5fa; margin-top: 0.5rem;">₹<%= String.format("%.2f", needs) %></p>
                        </div>
                        <div class="summary-card" style="padding: 1rem; border-top: 4px solid #a78bfa;">
                            <h3 style="font-size: 0.9rem;">Wants (<%= sWants %>%)</h3>
                            <p style="font-size: 1.1rem; font-weight: bold; color: #a78bfa; margin-top: 0.5rem;">₹<%= String.format("%.2f", wants) %></p>
                        </div>
                        <div class="summary-card" style="padding: 1rem; border-top: 4px solid #10b981;">
                            <h3 style="font-size: 0.9rem;">Savings (<%= sSavings %>%)</h3>
                            <p style="font-size: 1.1rem; font-weight: bold; color: #34d399; margin-top: 0.5rem;">₹<%= String.format("%.2f", savings) %></p>
                        </div>
                    </div>
                    
                    <!-- Custom Split Trigger -->
                    <div style="text-align:center; margin-top:1.5rem;">
                        <button onclick="toggleSplitForm()" class="btn" style="width:auto; padding:0.5rem 1rem; font-size:0.85rem; background:rgba(255,255,255,0.05); color:#94a3b8; border:1px solid rgba(255,255,255,0.1);">
                            <i class="fas fa-cog"></i> Customize Split
                        </button>
                    </div>

                    <!-- Hidden Split Form -->
                    <div id="splitForm" style="display:none; margin-top:1.5rem; background:rgba(15,23,42,0.4); padding:1.5rem; border-radius:1rem; border:1px solid rgba(16,185,129,0.2);">
                        <form action="updateBudgetSplit" method="post" onsubmit="return validateSplit()">
                            <div style="display:flex; gap:1rem; margin-bottom:1rem;">
                                <div style="flex:1;">
                                    <label style="font-size:0.8rem; color:#94a3b8; display:block; margin-bottom:0.5rem;">Needs %</label>
                                    <input type="number" id="inpNeeds" name="needs" value="<%= sNeeds %>" min="0" max="100" style="width:100%;" oninput="updateTotalSplit()">
                                </div>
                                <div style="flex:1;">
                                    <label style="font-size:0.8rem; color:#94a3b8; display:block; margin-bottom:0.5rem;">Wants %</label>
                                    <input type="number" id="inpWants" name="wants" value="<%= sWants %>" min="0" max="100" style="width:100%;" oninput="updateTotalSplit()">
                                </div>
                                <div style="flex:1;">
                                    <label style="font-size:0.8rem; color:#94a3b8; display:block; margin-bottom:0.5rem;">Savings %</label>
                                    <input type="number" id="inpSavings" name="savings" value="<%= sSavings %>" min="0" max="100" style="width:100%;" oninput="updateTotalSplit()">
                                </div>
                            </div>
                            <div style="display:flex; justify-content:space-between; align-items:center;">
                                <span id="splitTotalLabel" style="font-size:0.85rem; color:#10b981;">Total: 100%</span>
                                <button type="submit" id="saveSplitBtn" class="btn" style="width:auto; padding:0.5rem 1.5rem;">Save</button>
                            </div>
                        </form>
                    </div>
                </div>
                <% } %>
            </div>

            <!-- Right Side: Chart -->
            <% if (!categoryData.isEmpty()) { %>
            <div style="flex: 1; min-width: 300px; background: rgba(0,0,0,0.2); border-radius: 1.5rem; padding: 2rem; display: flex; flex-direction: column; align-items: center; justify-content: center;">
                <h3 style="margin-bottom: 2rem; color: #cbd5e1;">Category Breakdown</h3>
                <div style="width: 100%; max-width: 300px;">
                    <canvas id="categoryChart"></canvas>
                </div>
            </div>
            <% } else { %>
            <div style="flex: 1; min-width: 300px; background: rgba(0,0,0,0.2); border-radius: 1.5rem; padding: 2rem; display: flex; flex-direction: column; align-items: center; justify-content: center;">
                 <h3 style="color: #64748b;">No expense data to chart yet.</h3>
            </div>
            <% } %>
        </div>

        <div style="text-align: center; margin-top: 2rem;">
             <a href="dashboard.jsp" class="btn" style="width: auto; padding: 0.75rem 2rem;">Back to Dashboard</a>
        </div>
    </div>
</div>

<% if (!categoryData.isEmpty()) { %>
<script>
document.addEventListener("DOMContentLoaded", function() {
    const ctx = document.getElementById('categoryChart').getContext('2d');
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: <%= labels.toString() %>,
            datasets: [{
                data: <%= data.toString() %>,
                backgroundColor: [
                    '#3b82f6', // Bright Blue (Needs)
                    '#f59e0b', // Amber (Wants)
                    '#10b981', // Emerald (Savings)
                    '#a78bfa', // Violet
                    '#f43f5e', // Rose
                    '#06b6d4'  // Cyan
                ],
                borderColor: '#0f172a',
                borderWidth: 4,
                hoverOffset: 12
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: { color: '#cbd5e1', padding: 20, font: { family: 'Inter', size: 13 } }
                },
                tooltip: {
                    backgroundColor: 'rgba(15, 23, 42, 0.9)',
                    titleFont: { size: 14, family: 'Inter' },
                    bodyFont: { size: 16, family: 'Inter', weight: 'bold' },
                    padding: 12,
                    displayColors: true,
                    callbacks: {
                        label: function(context) {
                            return ' ₹' + context.parsed.toFixed(2);
                        }
                    }
                }
            },
            cutout: '65%'
        }
    });

    // Count Up Animations
    document.querySelectorAll('.count-up').forEach(el => {
        const target = parseFloat(el.getAttribute('data-target'));
        if(!target || isNaN(target)) { el.innerText = '₹0.00'; return; }
        let current = 0;
        const inc = target / 30; // 30 frames
        const timer = setInterval(() => {
            current += inc;
            if (current >= target) {
                clearInterval(timer);
                el.innerText = '₹' + target.toFixed(2);
            } else {
                el.innerText = '₹' + current.toFixed(2);
            }
        }, 30);
    });

    document.querySelectorAll('.count-up-int').forEach(el => {
        const target = parseInt(el.getAttribute('data-target'));
        if(!target || isNaN(target)) { el.innerText = '0'; return; }
        let current = 0;
        const inc = Math.max(1, Math.ceil(target / 30));
        const timer = setInterval(() => {
            current += inc;
            if (current >= target) {
                clearInterval(timer);
                el.innerText = target;
            } else {
                el.innerText = current;
            }
        }, 30);
    });
});

function toggleSplitForm() {
    const form = document.getElementById('splitForm');
    form.style.display = (form.style.display === 'none') ? 'block' : 'none';
}

function updateTotalSplit() {
    const n = parseInt(document.getElementById('inpNeeds').value) || 0;
    const w = parseInt(document.getElementById('inpWants').value) || 0;
    const s = parseInt(document.getElementById('inpSavings').value) || 0;
    const total = n + w + s;
    const label = document.getElementById('splitTotalLabel');
    const btn = document.getElementById('saveSplitBtn');
    
    label.innerText = 'Total: ' + total + '%';
    if (total === 100) {
        label.style.color = '#10b981';
        btn.disabled = false;
        btn.style.opacity = '1';
    } else {
        label.style.color = '#f43f5e';
        btn.disabled = true;
        btn.style.opacity = '0.5';
    }
}

function validateSplit() {
    const n = parseInt(document.getElementById('inpNeeds').value) || 0;
    const w = parseInt(document.getElementById('inpWants').value) || 0;
    const s = parseInt(document.getElementById('inpSavings').value) || 0;
    if (n + w + s !== 100) {
        alert("Total must equal 100%");
        return false;
    }
    return true;
}
</script>
<% } %>

<jsp:include page="footer.jsp" />
