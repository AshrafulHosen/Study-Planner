<?php
// Filename: profile.php
// Destination: /study_planner/pages/profile.php

declare(strict_types=1);

require_once __DIR__ . '/../includes/db.php';
require_once __DIR__ . '/../includes/auth.php';

require_login();

$user = current_user();
$userId = (int) $user['id'];
$errors = [];

// Fetch latest user details
$userDetails = fetch_one('SELECT * FROM users WHERE id = ?', 'i', [$userId]);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    verify_csrf();
    
    $action = $_POST['action'] ?? '';
    
    if ($action === 'update_profile') {
        $fullName = trim($_POST['full_name'] ?? '');
        $email = trim($_POST['email'] ?? '');
        
        if (empty($email)) {
            $errors['email'] = 'Email is required.';
        } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $errors['email'] = 'Invalid email address.';
        } else {
            // Check if email belongs to someone else
            $existing = fetch_one('SELECT id FROM users WHERE email = ? AND id != ?', 'si', [$email, $userId]);
            if ($existing) {
                $errors['email'] = 'Email is already taken.';
            }
        }
        
        if (empty($errors)) {
            $success = execute_statement('UPDATE users SET full_name = ?, email = ? WHERE id = ?', 'ssi', [$fullName, $email, $userId]);
            if ($success) {
                set_flash('success', 'Profile updated successfully.');
                redirect('pages/profile.php');
            } else {
                $errors['general'] = 'Failed to update profile.';
            }
        }
    } elseif ($action === 'update_password') {
        $currentPassword = $_POST['current_password'] ?? '';
        $newPassword = $_POST['new_password'] ?? '';
        $confirmPassword = $_POST['confirm_password'] ?? '';
        
        if (empty($currentPassword)) {
            $errors['current_password'] = 'Current password is required.';
        } elseif (!password_verify($currentPassword, $userDetails['password_hash'])) {
            $errors['current_password'] = 'Incorrect current password.';
        }
        
        if (empty($newPassword)) {
            $errors['new_password'] = 'New password is required.';
        } elseif (strlen($newPassword) < 8) {
            $errors['new_password'] = 'Password must be at least 8 characters long.';
        }
        
        if ($newPassword !== $confirmPassword) {
            $errors['confirm_password'] = 'Passwords do not match.';
        }
        
        if (empty($errors)) {
            $hash = password_hash($newPassword, PASSWORD_BCRYPT, ['cost' => PASSWORD_HASH_COST]);
            $success = execute_statement('UPDATE users SET password_hash = ? WHERE id = ?', 'si', [$hash, $userId]);
            
            if ($success) {
                set_flash('success', 'Password updated successfully.');
                redirect('pages/profile.php');
            } else {
                $errors['general'] = 'Failed to update password.';
            }
        }
    }
}

$pageTitle = 'My Profile';
require_once __DIR__ . '/../includes/header.php';
?>

<div class="row mb-4">
    <div class="col-12">
        <h2 class="h3 mb-1">My Profile</h2>
        <p class="text-muted mb-0">Manage your account settings and password.</p>
    </div>
</div>

<?php if (!empty($errors['general'])): ?>
    <div class="alert alert-danger"><?= h($errors['general']) ?></div>
<?php endif; ?>

<div class="row g-4">
    <div class="col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0 pt-4 pb-0">
                <h5 class="fw-bold mb-0">Profile Information</h5>
            </div>
            <div class="card-body">
                <form method="post" action="">
                    <?= csrf_field() ?>
                    <input type="hidden" name="action" value="update_profile">
                    
                    <div class="mb-3">
                        <label class="form-label text-muted small fw-bold text-uppercase">Username</label>
                        <input type="text" class="form-control bg-light" value="<?= h($userDetails['username']) ?>" disabled>
                        <div class="form-text">Username cannot be changed.</div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="full_name" class="form-label text-muted small fw-bold text-uppercase">Full Name</label>
                        <input type="text" class="form-control" id="full_name" name="full_name" value="<?= h($_POST['full_name'] ?? $userDetails['full_name']) ?>">
                    </div>
                    
                    <div class="mb-4">
                        <label for="email" class="form-label text-muted small fw-bold text-uppercase">Email Address <span class="text-danger">*</span></label>
                        <input type="email" class="form-control <?= isset($errors['email']) ? 'is-invalid' : '' ?>" id="email" name="email" value="<?= h($_POST['email'] ?? $userDetails['email']) ?>" required>
                        <?php if (isset($errors['email'])): ?>
                            <div class="invalid-feedback"><?= h($errors['email']) ?></div>
                        <?php endif; ?>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </form>
            </div>
        </div>
    </div>
    
    <div class="col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0 pt-4 pb-0">
                <h5 class="fw-bold mb-0">Change Password</h5>
            </div>
            <div class="card-body">
                <form method="post" action="">
                    <?= csrf_field() ?>
                    <input type="hidden" name="action" value="update_password">
                    
                    <div class="mb-3">
                        <label for="current_password" class="form-label text-muted small fw-bold text-uppercase">Current Password</label>
                        <input type="password" class="form-control <?= isset($errors['current_password']) ? 'is-invalid' : '' ?>" id="current_password" name="current_password" required>
                        <?php if (isset($errors['current_password'])): ?>
                            <div class="invalid-feedback"><?= h($errors['current_password']) ?></div>
                        <?php endif; ?>
                    </div>
                    
                    <div class="mb-3">
                        <label for="new_password" class="form-label text-muted small fw-bold text-uppercase">New Password</label>
                        <input type="password" class="form-control <?= isset($errors['new_password']) ? 'is-invalid' : '' ?>" id="new_password" name="new_password" required>
                        <?php if (isset($errors['new_password'])): ?>
                            <div class="invalid-feedback"><?= h($errors['new_password']) ?></div>
                        <?php endif; ?>
                        <div class="form-text">Must be at least 8 characters.</div>
                    </div>
                    
                    <div class="mb-4">
                        <label for="confirm_password" class="form-label text-muted small fw-bold text-uppercase">Confirm New Password</label>
                        <input type="password" class="form-control <?= isset($errors['confirm_password']) ? 'is-invalid' : '' ?>" id="confirm_password" name="confirm_password" required>
                        <?php if (isset($errors['confirm_password'])): ?>
                            <div class="invalid-feedback"><?= h($errors['confirm_password']) ?></div>
                        <?php endif; ?>
                    </div>
                    
                    <button type="submit" class="btn btn-warning">Update Password</button>
                </form>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
