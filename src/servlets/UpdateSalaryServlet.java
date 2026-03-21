package servlets;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

import db.DBConnection;

@WebServlet("/updateSalary")
public class UpdateSalaryServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        int userId = (int) session.getAttribute("userId");
        String salaryStr = request.getParameter("salary");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "UPDATE users SET salary = ? WHERE id = ?")) {
            ps.setDouble(1, Double.parseDouble(salaryStr));
            ps.setInt(2, userId);
            ps.executeUpdate();
            response.sendRedirect("dashboard.jsp?msg=salary_updated");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=salary_failed");
        }
    }
}
