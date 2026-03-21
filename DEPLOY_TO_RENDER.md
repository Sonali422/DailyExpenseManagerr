# 🚀 Deploy Daily Expense Manager — Complete Guide

## STEP 1: Create Supabase Database (5 mins)

1. Go to → https://supabase.com/dashboard/sign-up
2. Sign up with **GitHub** (same account as your code).
3. Click **"New Project"**.
4. Fill in:
   - **Project Name**: `daily-expense-manager`
   - **Database Password**: choose a strong password (SAVE IT!)
   - **Region**: pick closest to you
5. Click **"Create new project"** (takes ~2 mins to spin up).
6. Once ready, go to: **Project Settings** → **Database** → scroll to **"Connection string"** → select **"URI"** tab.
7. Copy the string. It looks like:
   ```
   postgresql://postgres.xxxx:YOUR_PASSWORD@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres
   ```
8. **IMPORTANT**: Change `postgresql://` to `jdbc:postgresql://` at the start.
9. Your final DATABASE_URL looks like:
   ```
   jdbc:postgresql://postgres.xxxx:YOUR_PASSWORD@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres
   ```

---

## STEP 2: Deploy to Render (5 mins)

1. Go to → https://dashboard.render.com
2. **Sign up / Log in** using GitHub (complete the captcha if prompted).
3. Once on the dashboard, click **"New +"** → **"Web Service"**.
4. Under "Connect a repository", find **DailyExpenseManagerr** → Click **"Connect"**.
5. Fill in these settings:

   | Setting | Value |
   |---------|-------|
   | **Name** | `daily-expense-manager` |
   | **Region** | Oregon (US West) |
   | **Branch** | `main` |
   | **Runtime** | `Docker` ← IMPORTANT |
   | **Plan** | `Free` |

6. Scroll to **"Environment Variables"** and click **"Add Environment Variable"**:

   | Key | Value |
   |-----|-------|
   | `DATABASE_URL` | (paste your Supabase JDBC URI from Step 1) |

7. Click **"Create Web Service"** 🎉

---

## STEP 3: Wait for Deployment (~5-10 mins)

- Watch the **Logs** tab in Render.
- Wait for: `INFO: Server startup in XXXX ms`
- Your public URL will be shown at the top, like:
  ```
  https://daily-expense-manager.onrender.com
  ```

---

## STEP 4: Test Your Live App

Open your URL and test:
- ✅ Register a new account
- ✅ Add an expense
- ✅ View monthly summary
- ✅ Refresh the page — data should still be there!

---

## 🔧 Troubleshooting

| Problem | Fix |
|---------|-----|
| App shows 503 | Wait 2-3 mins (free tier cold start) |
| Database error | Double-check your `DATABASE_URL` value in Render env vars |
| Build fails | Check the Render Logs for error messages |

---

> [!TIP]
> **Free Tier Note**: Render free services spin down after 15 min of inactivity. First load may take 30-60 seconds. For always-on, upgrade to Render's $7/mo plan.
