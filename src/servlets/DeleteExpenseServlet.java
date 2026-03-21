package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import db.DBConnection;

@WebServlet("/deleteExpense")
public class DeleteExpenseServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String idParam = request.getParameter("id");

        if (idParam != null) {
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("DELETE FROM expenses WHERE id=? AND user_id=?")) {

                ps.setInt(1, Integer.parseInt(idParam));
                ps.setInt(2, userId);
                ps.executeUpdate();
                
                response.sendRedirect("viewExpenses?successMsg=Expense%20deleted%20successfully");

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("viewExpenses?errorMsg=Failed%20to%20delete%20expense");
            }
        } else {
            response.sendRedirect("viewExpenses");
        }
    }
}
