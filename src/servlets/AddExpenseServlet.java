package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import db.DBConnection;

@WebServlet("/addExpense")
public class AddExpenseServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        String title = request.getParameter("title");
        String amount = request.getParameter("amount");
        String category = request.getParameter("category");
        String date = request.getParameter("date");

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO expenses(user_id,title,amount,category,expense_date) VALUES (?,?,?,?,?)");

            ps.setInt(1, userId);
            ps.setString(2, title);
            ps.setDouble(3, Double.parseDouble(amount));
            ps.setString(4, category);
            ps.setString(5, date);

            ps.executeUpdate();

            response.sendRedirect("dashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
