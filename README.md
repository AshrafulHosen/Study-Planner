# Study Planner

A complete PHP + MySQL study management web application for XAMPP.

## Project Overview

Study Planner helps students manage subjects, study sessions, weekly goals, tasks, notes, progress reports, calendar views, profiles, and admin oversight in one responsive web app.

## Tech Stack

- PHP 8+
- MySQL
- HTML5
- CSS3
- JavaScript
- Bootstrap 5
- XAMPP

## Folder Structure

```text
study_planner/
├── index.php
├── README.md
├── study_planner.sql
├── css/
│   └── style.css
├── assets/
│   └── js/
│       └── app.js
├── includes/
│   ├── db.php
│   ├── auth.php
│   └── layout.php
├── pages/
│   ├── login.php
│   ├── register.php
│   ├── logout.php
│   ├── forgot_password.php
│   ├── reset_password.php
│   ├── dashboard.php
│   ├── goals.php
│   ├── subjects.php
│   ├── sessions.php
│   ├── tasks.php
│   ├── notes.php
│   ├── reports.php
│   ├── history.php
│   ├── calendar.php
│   ├── profile.php
│   └── admin/
│       ├── index.php
│       ├── users.php
│       └── reports.php
└── uploads/
```

## Installation Guide

1. Copy the `study_planner` folder into `htdocs`.
2. Start Apache and MySQL in XAMPP.
3. Open phpMyAdmin and create a database named `study_planner`.
4. Import `study_planner.sql` into that database.
5. Open `includes/db.php` and confirm the DB credentials match your local setup.
6. Visit `http://localhost/study_planner/`.

## Database Import Instructions

1. Open phpMyAdmin.
2. Select the `study_planner` database.
3. Click Import.
4. Choose `study_planner.sql`.
5. Run the import.

If you already imported the schema earlier, you do not need to import it again.

## Default Admin Setup

The SQL file does not seed user accounts by default.

To create an admin manually:

1. Register a user from the app.
2. In phpMyAdmin, update that user to admin:

```sql
UPDATE users SET role = 'admin' WHERE email = 'your-email@example.com';
```

You can also create a dedicated admin account through the normal registration form and then promote it.

## GitHub Setup Instructions

1. Initialize a git repository in the project folder.
2. Commit the project files.
3. Create a repository on GitHub.
4. Add the GitHub remote.
5. Push the branch to GitHub.

Example commands:

```bash
git init
git add .
git commit -m "Initial Study Planner build"
git branch -M main
git remote add origin <your-repo-url>
git push -u origin main
```

## Feature List

### Authentication

- Register
- Login
- Logout
- Forgot password
- Reset password
- Password hashing with bcrypt
- Session management
- CSRF protection
- Prepared statements

### Dashboard

- Welcome message
- Total subjects
- Total study sessions
- Total study hours
- Weekly study hours
- Daily progress
- Completed tasks
- Pending tasks
- Progress percentage
- Study streak
- Quick navigation cards

### Subjects

- Add subject
- Edit subject
- Delete subject
- Search subjects
- Subject colors and descriptions

### Sessions

- Add session
- Edit session
- Delete session
- Study duration auto-calculation
- Session history

### Weekly Goals

- Set weekly goals per subject
- Update goals
- Progress bars by subject

### Tasks

- Add task
- Edit task
- Delete task
- Toggle completed status
- Filter by status
- Filter by subject
- Search tasks

### Notes

- Create notes
- Edit notes
- Delete notes
- Search notes

### Reports

- Daily reports
- Weekly reports
- Monthly reports
- Subject-wise summaries
- Study totals
- Progress summary

### Calendar

- Monthly calendar view
- Highlight study days
- Session details by selected day
- Upcoming tasks
- Upcoming goals

### Profile

- View profile
- Edit full name
- Change password
- Optional profile picture upload

### Admin Panel

- View users
- Delete users
- View statistics
- Manage platform data

## Security Notes

- Passwords are hashed with `password_hash()` using bcrypt cost 12.
- All forms include CSRF tokens.
- Database access uses prepared statements.
- User data is filtered by `user_id`.
- Output is escaped with `htmlspecialchars()` through helper functions.

## Project Report Summary

Study Planner is a responsive academic productivity system designed for local XAMPP deployment. It combines authentication, study planning, task tracking, note taking, reporting, calendar visualization, and admin oversight in one structured application. The interface is built with Bootstrap 5 and a custom lightweight theme for clear navigation on desktop and mobile.
