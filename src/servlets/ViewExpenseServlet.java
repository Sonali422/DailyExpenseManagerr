package servlets;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import db.DBConnection;

@WebServlet("/viewExpenses")
public class ViewExpenseServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        List<Map<String, Object>> expenses = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM expenses WHERE user_id=? ORDER BY expense_date DESC")) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> exp = new HashMap<>();
                    exp.put("id", rs.getInt("id"));
                    exp.put("expense_date", rs.getString("expense_date"));
                    exp.put("category", rs.getString("category"));
                    exp.put("title", rs.getString("title"));
                    exp.put("amount", rs.getDouble("amount"));
                    expenses.add(exp);
                }
            }

            request.setAttribute("expenses", expenses);
            request.getRequestDispatcher("viewExpenses.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=Server");
        }
    }
}
