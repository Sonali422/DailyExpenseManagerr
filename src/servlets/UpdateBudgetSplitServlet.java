package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

import db.DBConnection;

@WebServlet("/updateBudgetSplit")
public class UpdateBudgetSplitServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        int needs = Integer.parseInt(request.getParameter("needs"));
        int wants = Integer.parseInt(request.getParameter("wants"));
        int savings = Integer.parseInt(request.getParameter("savings"));

        if (needs + wants + savings != 100) {
            response.sendRedirect("monthlySummary?month=current&error=SplitTotal");
            return;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "UPDATE users SET split_needs=?, split_wants=?, split_savings=? WHERE id=?")) {

            ps.setInt(1, needs);
            ps.setInt(2, wants);
            ps.setInt(3, savings);
            ps.setInt(4, userId);

            ps.executeUpdate();
            response.sendRedirect("monthlySummary?month=current&success=SplitUpdated");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("monthlySummary?month=current&error=Server");
        }
    }
}
