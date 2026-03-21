package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

import db.DBConnection;

@WebServlet("/forgotPassword")
public class ForgotPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE email=?")) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // In a real app, send a secure link via email. 
                    // For this demo, we direct to reset page with email.
                    response.sendRedirect("resetPassword.jsp?email=" + email);
                } else {
                    response.sendRedirect("forgotPassword.jsp?errorMsg=Email not found in our records.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("forgotPassword.jsp?errorMsg=Server error occurred.");
        }
    }
}
