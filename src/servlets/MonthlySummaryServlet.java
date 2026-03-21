package servlets;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;

import java.io.IOException;
import java.sql.*;

import db.DBConnection;

@WebServlet("/monthlySummary")
public class MonthlySummaryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String monthFilter = request.getParameter("month");
        if (monthFilter == null) monthFilter = "all";
        
        String dateCondition = "";
        if ("current".equals(monthFilter)) {
             dateCondition = " AND strftime('%Y-%m', expense_date) = strftime('%Y-%m', 'now')";
        } else if ("last".equals(monthFilter)) {
             dateCondition = " AND strftime('%Y-%m', expense_date) = strftime('%Y-%m', 'now', '-1 month')";
        }

        int userId = (int) session.getAttribute("userId");
        double total = 0.0;
        int count = 0;
        double highest = 0.0;
        int sNeeds = 50, sWants = 30, sSavings = 20;

        try (Connection con = DBConnection.getConnection()) {
             // Fetch splits and salary
             try (PreparedStatement psUser = con.prepareStatement("SELECT split_needs, split_wants, split_savings FROM users WHERE id=?")) {
                 psUser.setInt(1, userId);
                 try (ResultSet rsUser = psUser.executeQuery()) {
                     if (rsUser.next()) {
                         sNeeds = rsUser.getInt("split_needs");
                         sWants = rsUser.getInt("split_wants");
                         sSavings = rsUser.getInt("split_savings");
                     }
                 }
             }

             // Fetch expense stats
             try (PreparedStatement ps = con.prepareStatement(
                      "SELECT SUM(amount) as total, COUNT(id) as cnt, MAX(amount) as highest FROM expenses WHERE user_id=?" + dateCondition)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        total = rs.getDouble("total");
                        count = rs.getInt("cnt");
                        highest = rs.getDouble("highest");
                    }
                }
             }

            request.setAttribute("total", total);
            request.setAttribute("expenseCount", count);
            request.setAttribute("highestExpense", highest);
            request.setAttribute("monthFilter", monthFilter);
            request.setAttribute("splitNeeds", sNeeds);
            request.setAttribute("splitWants", sWants);
            request.setAttribute("splitSavings", sSavings);
            request.getRequestDispatcher("monthlySummary.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=Server");
        }
    }
}
