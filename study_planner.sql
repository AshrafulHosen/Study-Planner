-- Filename: study_planner.sql
-- Destination: /study_planner/study_planner.sql

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS notes;
DROP TABLE IF EXISTS tasks;
DROP TABLE IF EXISTS quick_notes;
DROP TABLE IF EXISTS todos;
DROP TABLE IF EXISTS weekly_goals;
DROP TABLE IF EXISTS study_sessions;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS password_resets;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE users (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('student', 'admin') NOT NULL DEFAULT 'student',
    profile_picture VARCHAR(255) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME NULL,
    UNIQUE KEY uq_users_username (username),
    UNIQUE KEY uq_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE password_resets (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL,
    token VARCHAR(128) NOT NULL,
    expires_at DATETIME NOT NULL,
    used TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_password_resets_token (token),
    KEY idx_password_resets_user_id (user_id),
    CONSTRAINT fk_password_resets_user_id
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE subjects (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NULL,
    color VARCHAR(7) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_subjects_user_name (user_id, name),
    KEY idx_subjects_user_id (user_id),
    CONSTRAINT fk_subjects_user_id
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE study_sessions (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL,
    subject_id INT UNSIGNED NOT NULL,
    session_date DATE NOT NULL,
    start_time TIME NULL,
    end_time TIME NULL,
    duration_min INT UNSIGNED NOT NULL,
    notes TEXT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_study_sessions_user_id (user_id),
    KEY idx_study_sessions_subject_id (subject_id),
    KEY idx_study_sessions_date (session_date),
    CONSTRAINT fk_study_sessions_user_id
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_study_sessions_subject_id
        FOREIGN KEY (subject_id) REFERENCES subjects(id)
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE weekly_goals (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL,
    subject_id INT UNSIGNED NOT NULL,
    goal_hours DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    week_start DATE NOT NULL,
    UNIQUE KEY uq_weekly_goals_user_subject_week (user_id, subject_id, week_start),
    KEY idx_weekly_goals_user_id (user_id),
    KEY idx_weekly_goals_subject_id (subject_id),
    CONSTRAINT fk_weekly_goals_user_id
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_weekly_goals_subject_id
        FOREIGN KEY (subject_id) REFERENCES subjects(id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE tasks (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL,
    subject_id INT UNSIGNED NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NULL,
    due_date DATE NULL,
    priority ENUM('low', 'medium', 'high') NOT NULL DEFAULT 'medium',
    status ENUM('pending', 'completed') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    KEY idx_tasks_user_id (user_id),
    KEY idx_tasks_subject_id (subject_id),
    KEY idx_tasks_status (status),
    KEY idx_tasks_due_date (due_date),
    CONSTRAINT fk_tasks_user_id
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_tasks_subject_id
        FOREIGN KEY (subject_id) REFERENCES subjects(id)
        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE notes (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL,
    subject_id INT UNSIGNED NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY idx_notes_user_id (user_id),
    KEY idx_notes_subject_id (subject_id),
    KEY idx_notes_title (title),
    CONSTRAINT fk_notes_user_id
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_notes_subject_id
        FOREIGN KEY (subject_id) REFERENCES subjects(id)
        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
