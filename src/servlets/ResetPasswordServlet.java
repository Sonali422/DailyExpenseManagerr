package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

import db.DBConnection;

@WebServlet("/resetPassword")
public class ResetPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("UPDATE users SET password=? WHERE email=?")) {

            ps.setString(1, password);
            ps.setString(2, email);

            int updated = ps.executeUpdate();
            if (updated > 0) {
                response.sendRedirect("index.jsp?successMsg=Password updated successfully! Please login with your new password.");
            } else {
                response.sendRedirect("index.jsp?errorMsg=Could not update password.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?errorMsg=Server error occurred.");
        }
    }
}
