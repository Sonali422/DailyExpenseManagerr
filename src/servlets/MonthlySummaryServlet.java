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

        int userId = (int) session.getAttribute("userId");

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(
                            "SELECT SUM(amount) total FROM expenses WHERE user_id=?");

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            request.setAttribute("summary", rs);

            request.getRequestDispatcher("monthlySummary.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
