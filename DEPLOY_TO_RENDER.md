# Professional Deployment Guide: Daily Expense Manager on Render 🚀

This guide provides the exact steps to host your application **24/7** with a **public URL**, completely **independent of your local machine**.

## 🏗️ Architecture for 24/7 Uptime
To move away from "Localhost", we use a **Decoupled Cloud Architecture**:
- **Application**: Render (Handles the Java/Tomcat logic).
- **Database**: Supabase (Handles persistent data storage).
- **Packaging**: Docker (The modern standard that Render uses for Tomcat apps).

---

## 📋 Phase 1: Prepare the Cloud Database (Supabase)
Since SQLite files are deleted on Render's free tier, we use **Supabase** (PostgreSQL) for permanent storage.
1.  Sign up at [Supabase.com](https://supabase.com/).
2.  Create a new project (e.g., `ExpenseManager`).
3.  Go to **Project Settings** > **Database**.
4.  Copy the **Connection String** (URI format).
    - It looks like: `jdbc:postgresql://db.xxxx.supabase.co:5432/postgres?user=postgres&password=YOUR_PASSWORD`

---

## 📦 Phase 2: Push to GitHub
I have already updated your code to be "Cloud Ready" (supporting dynamic ports and remote databases).
Ensure your latest changes are on GitHub:
```bash
git add .
git commit -m "feat: finalize for 24/7 cloud deployment"
git push origin main
```

---

## 🚀 Phase 3: Deploy to Render
1.  Login to [Render.com](https://render.com/).
2.  Click **New +** > **Web Service**.
3.  Connect your GitHub repository: `Sonali422/DailyExpenseManagerr`.
4.  **Important Settings**:
    - **Runtime**: `Docker`
    - **Plan**: `Free`
5.  **Environment Variables (CRITICAL)**:
    - Add `DATABASE_URL` = (Your Supabase URI from Phase 1).
6.  Click **Deploy Web Service**.

---

## ✅ Phase 4: Verification
1.  Monitor the **Logs** in Render. You should see `Deployment Successful`.
2.  Open the provided **Public URL** (e.g., `https://daily-expense-manager.onrender.com`).
3.  **Test**: Add an expense and refresh the page. Your data is now safely stored in the cloud!

---

## 🛠️ Maintenance & FAQ
- **WAR File**: While I provided a Dockerfile (standard for Render), if you need a `.war` file for local backup, run:
  `jar -cvf DailyExpenseManager.war -C WebContent .`
- **Continuity**: Your app will now stay online even if your laptop is closed. 
- **Port Binding**: The `Dockerfile` is pre-configured to automatically bind to Render's dynamic `$PORT`.

> [!TIP]
> Your app is now a professional-grade web service. You can share the public URL with anyone!
