# Deployment Guide for DailyExpenseManager 🚀

This project is a Java Servlet + JSP application using SQLite. Below are the steps to deploy it to modern cloud platforms like **Render** or **Railway**.

## Option 1: Deploy using Docker (Recommended)
This is the easiest way to ensure all dependencies (Tomcat, JDK, SQLite) are correctly configured.

### Using Render
1.  **Push your code** to a GitHub repository.
2.  Login to [Render](https://render.com/).
3.  Click **New +** > **Web Service**.
4.  Connect your repository.
5.  Set **Runtime** to `Docker`.
6.  **Environment Variables**:
    *   Add `SQLITE_DB_PATH` = `/usr/local/tomcat/database/expense_db.db`.
7.  **Persistent Disk (Critical for SQLite)**: 
    *   Go to **Dashboard** > **Disk**.
    *   Mount a disk at `/usr/local/tomcat/database` (Size: 1GB is plenty).
8.  Deploy!

### Using Railway
1.  Connect your GitHub repo to **Railway**.
2.  Add a **Volume** in Railway settings fixed to `/usr/local/tomcat/database`.
3.  Add **Environment Variable**: `SQLITE_DB_PATH` = `/usr/local/tomcat/database/expense_db.db`.
4.  Deploy!

## Option 2: Manual Java Hosting
If you use a platform that only supports WAR files (like older AWS Elastic Beanstalk or Heroku with Maven):
1.  Package the `WebContent` folder as a `.war` file.
2.  Upload to the provider.
3.  Ensure `servlet-api.jar` and `sqlite-jdbc.jar` are included in `WEB-INF/lib`.

## Database Tips
> [!IMPORTANT]
> Since SQLite is a file-based database, your data will be **deleted** every time the server restarts unless you use a **Persistent Volume/Disk**. 
> For mission-critical apps, we recommend switching to **PostgreSQL** or **MySQL** by updating `DBConnection.java`.

## Final Public URL
Once deployed, your URL will look like: 
`https://your-app-name.onrender.com` or `https://your-app-name.up.railway.app`
