# "Forever Free" Deployment Guide 💸

This guide explains how to host your Expense Manager for **$0/month** by using two free services together.

## The Strategy
- **Application Server**: [Render](https://render.com/) (Free Tier)
- **Database**: [Supabase](https://supabase.com/) or [Neon](https://neon.tech/) (Free PostgreSQL)

By using an external database, you don't need a "Persistent Disk" on Render, which usually costs money.

---

## Step 1: Create a Free PostgreSQL Database
1.  Sign up at [Supabase](https://supabase.com/).
2.  Create a new project (e.g., `ExpenseManagerDB`).
3.  Go to **Project Settings** > **Database**.
4.  Copy the **Connection String** (choose "URI" and "JDBC" compatible).
    *   It will look like: `jdbc:postgresql://db.xxxx.supabase.co:5432/postgres?user=postgres&password=YOUR_PASSWORD`

## Step 2: Push your code to GitHub
I have already updated your code to support PostgreSQL! Make sure your latest changes are pushed:
```bash
git add .
git commit -m "feat: support postgres for free cloud hosting"
git push origin main
```

## Step 3: Deploy to Render (Free)
1.  Login to [Render](https://render.com/).
2.  Create a **New Web Service** from your GitHub repo.
3.  Set **Runtime** to `Docker`.
4.  **Environment Variables (CRITICAL)**:
    *   Add `DATABASE_URL` = (The Connection String you copied in Step 1).
5.  **Skip the Disk**: You do **NOT** need to mount a disk for this method.
6.  Deploy!

---

## Why this is better:
- **Zero Cost**: Both services have a generous free tier.
- **Reliable Data**: Your data is stored in a professional managed database, not just a local file.
- **Scalable**: If your app grows, you can easily upgrade either part.

> [!NOTE]
> I have included the PostgreSQL JDBC driver in your project configuration. The app will automatically detect if you are using SQLite (locally) or PostgreSQL (in the cloud) based on the `DATABASE_URL` environment variable.
