<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily Expense Manager</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
      .nav-active { border-bottom: 2px solid #60a5fa; border-radius: 0; padding-bottom: 0.25rem; }
      .profile-icon { display: inline-flex; width: 2.5rem; height: 2.5rem; background: linear-gradient(135deg, #60a5fa, #a78bfa); border-radius: 50%; align-items: center; justify-content: center; font-weight: bold; color: white; margin-right: 0.5rem; }
      .user-greeting { display: flex; align-items: center; color: #fff; font-weight: 500; font-size: 1.1rem; }
    </style>
</head>
<body>
    <div id="toastContainer"></div>
    <header>
        <nav>
            <div class="brand">
                <a href="index.jsp" style="text-decoration:none;"><h1>ExpenseManager</h1></a>
            </div>
            <div class="menu-toggle" id="mobile-menu">
                <i class="fas fa-bars"></i>
            </div>
            <ul class="nav-menu">
                <%
                    Integer userId = null;
                    String userName = null;
                    HttpSession currentSession = request.getSession(false);
                    if (currentSession != null) {
                        userId = (Integer) currentSession.getAttribute("userId");
                        userName = (String) currentSession.getAttribute("userName");
                    }
                %>
                <% if (userId != null) { %>
                    <li style="display:flex; align-items:center; margin-right: 1.5rem;">
                        <span class="user-greeting">
                            <span class="profile-icon"><%= userName != null && userName.length() > 0 ? userName.substring(0,1).toUpperCase() : "U" %></span>
                            Hi, <%= userName != null ? userName : "User" %>
                        </span>
                    </li>
                    <li><a href="dashboard.jsp" class="nav-link"><i class="fas fa-chart-line"></i> Dashboard</a></li>
                    <li><a href="viewExpenses" class="nav-link"><i class="fas fa-history"></i> View Expenses</a></li>
                    <li><a href="addExpense.jsp" class="nav-link"><i class="fas fa-plus-circle"></i> Add Expense</a></li>
                    <li><a href="monthlySummary" class="nav-link"><i class="fas fa-chart-pie"></i> Summary</a></li>
                    <li><a href="logout" class="nav-link" style="color:#ef4444;"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                <% } else { %>
                    <li><a href="index.jsp" class="nav-link">Login</a></li>
                    <li><a href="register.jsp" class="nav-link">Register</a></li>
                <% } %>
            </ul>
        </nav>
    </header>
    
    <script>
        // Global notification script
        function showToast(message, type = 'success') {
            const container = document.getElementById('toastContainer');
            if (!container) return;
            const toast = document.createElement('div');
            toast.className = 'toast ' + type;
            toast.innerHTML = `<span>${message}</span> <button class="toast-close" onclick="this.parentElement.remove()">&times;</button>`;
            container.appendChild(toast);
            setTimeout(() => {
                if (toast.parentElement) {
                    toast.style.animation = 'toastOut 0.3s forwards';
                    setTimeout(() => toast.remove(), 300);
                }
            }, 5000);
        }

        // Active Link Highlight
        document.addEventListener("DOMContentLoaded", () => {
            const currentPath = window.location.pathname.split("/").pop() || "index.jsp";
            document.querySelectorAll(".nav-link").forEach(link => {
                const href = link.getAttribute("href");
                if (href === currentPath || currentPath.startsWith(href)) {
                    link.classList.add("nav-active");
                }
            });
            
            // Show toasts based on URL params globally if not handled locally
            const urlParams = new URLSearchParams(window.location.search);
            if(urlParams.get('successMsg')) {
                showToast(urlParams.get('successMsg'), 'success');
            }
            if(urlParams.get('errorMsg')) {
                showToast(urlParams.get('errorMsg'), 'error');
            }

            // Mobile menu toggle logic
            const menuToggle = document.getElementById('mobile-menu');
            const navMenu = document.querySelector('.nav-menu');
            
            if (menuToggle && navMenu) {
                menuToggle.addEventListener('click', () => {
                    navMenu.classList.toggle('active');
                    const icon = menuToggle.querySelector('i');
                    if (navMenu.classList.contains('active')) {
                        icon.classList.remove('fa-bars');
                        icon.classList.add('fa-times');
                    } else {
                        icon.classList.remove('fa-times');
                        icon.classList.add('fa-bars');
                    }
                });
            }
        });
    </script>
    <main>
