# 💰 Daily Expense Manager

A full-stack **Daily Expense Tracking Web Application** built with **Java Servlets**, **JSP**, **Tomcat 10**, and **PostgreSQL** (via Supabase). Deployable on **Render** using Docker — free, persistent, and publicly accessible.

---

## 🚀 Features

- **🔐 Secure Authentication** — Register & login with SHA-256 hashed passwords
- **📊 Dashboard** — View income, total expenses, and remaining balance at a glance
- **➕ Add Expenses** — Log expenses by title, amount, category, and date
- **📋 View & Filter Expenses** — Search by keyword, filter by category, date range, and sort by amount or date
- **📅 Monthly Summary** — Visualize spending broken down by month and category
- **✅ Success Notifications** — Smooth auto-hiding toast messages after actions
- **📱 Fully Responsive** — Mobile-friendly layout with hamburger navigation
- **☁️ Cloud-Ready** — Connects to Supabase (PostgreSQL) when deployed on Render

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Backend | Java Servlets (Jakarta EE) |
| Frontend | JSP, HTML5, CSS3, Vanilla JS |
| Server | Apache Tomcat 10.1 |
| Database | PostgreSQL (Supabase) / SQLite (local) |
| Containerization | Docker |
| Cloud Deployment | Render |
| Icons | Font Awesome 6 |
| Fonts | Google Fonts – Inter |

---

## 📁 Project Structure

```
DailyExpenseManager/
├── src/
│   ├── db/
│   │   └── DBConnection.java        # Handles SQLite (local) & PostgreSQL (cloud)
│   ├── servlets/
│   │   ├── LoginServlet.java
│   │   ├── RegisterServlet.java
│   │   ├── AddExpenseServlet.java
│   │   ├── ViewExpenseServlet.java
│   │   ├── DeleteExpenseServlet.java
│   │   ├── MonthlySummaryServlet.java
│   │   ├── LogoutServlet.java
│   │   └── ...
│   └── utils/
│       └── HashUtil.java            # SHA-256 password hashing
├── WebContent/
│   ├── css/
│   │   └── style.css                # Global glassmorphism dark theme
│   ├── images/
│   ├── index.jsp                    # Login page
│   ├── register.jsp
│   ├── dashboard.jsp
│   ├── addExpense.jsp
│   ├── viewExpenses.jsp
│   ├── monthlySummary.jsp
│   ├── header.jsp
│   └── footer.jsp
├── Dockerfile                       # Docker build + Tomcat deployment
├── build_and_run.sh                 # Local dev build script
├── db_setup.sql                     # Initial database schema
└── DEPLOY_TO_RENDER.md              # Step-by-step cloud deployment guide
```

---

## 🏃 Running Locally

### Prerequisites
- Java 17+
- Bash (Mac/Linux) or WSL (Windows)

### Steps
```bash
git clone https://github.com/Sonali422/DailyExpenseManagerr.git
cd DailyExpenseManagerr
bash build_and_run.sh
```

Then open your browser at: **[http://localhost:8080](http://localhost:8080)**

> No external database needed locally — the app uses SQLite as a fallback automatically.

---

## ☁️ Deploying to Render (Free)

### Step 1: Create a Supabase Database
1. Go to [supabase.com](https://supabase.com) → New Project
2. Copy your **URI** from Project Settings → Database → Connection String
3. Change `postgresql://` to `jdbc:postgresql://` at the beginning

### Step 2: Deploy on Render
1. Go to [render.com](https://render.com) → New Web Service → Connect this repo
2. Set **Runtime** to `Docker`
3. Under **Environment Variables**, add:

| Key | Value |
|-----|-------|
| `DATABASE_URL` | `jdbc:postgresql://your-supabase-url` |

4. Click **Create Web Service** — Render deploys automatically on every GitHub push 🎉

---

## 🗄️ Database Schema

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,      -- SHA-256 hashed
    salary DOUBLE PRECISION DEFAULT 0.0,
    split_needs INTEGER DEFAULT 50,
    split_wants INTEGER DEFAULT 30,
    split_savings INTEGER DEFAULT 20
);

CREATE TABLE expenses (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    title TEXT NOT NULL,
    amount DOUBLE PRECISION NOT NULL,
    category TEXT NOT NULL,
    expense_date TEXT NOT NULL
);
```

---

## 🔒 Security

- Passwords are **never stored in plain text** — hashed using SHA-256 before saving
- Each user's session is validated on every protected page
- All SQL queries use **PreparedStatements** to prevent SQL injection

---

## 📄 License

This project is open-source and free to use for educational and personal purposes.

---

## 👩‍💻 Author

**Sonali Karella** — [github.com/Sonali422](https://github.com/Sonali422)
