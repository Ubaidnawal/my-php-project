<?php
// admin/includes/permissions.php
// Role-Based Access Control (RBAC) Helper
// Roles: Super Admin (4), Admin (3), Manager (2), Staff (1)

/**
 * Get the role level as an integer for comparison.
 */
function get_role_level(?string $role): int {
    switch ($role) {
        case 'Super Admin': return 4;
        case 'Admin':       return 3;
        case 'Manager':     return 2;
        case 'Staff':       return 1;
        default:            return 0;
    }
}

/**
 * Get the current admin's role level.
 */
function current_role_level(): int {
    return get_role_level($_SESSION['admin_role'] ?? null);
}

/**
 * Check if the current admin has at least the required role level.
 */
function has_role(int $min_level): bool {
    return current_role_level() >= $min_level;
}

/**
 * Check if the current admin has a specific role name.
 */
function is_role(string $role_name): bool {
    return ($_SESSION['admin_role'] ?? null) === $role_name;
}

/**
 * Check if the current admin account is active.
 */
function is_active(): bool {
    return ($_SESSION['admin_status'] ?? '') === 'Active';
}

/**
 * Require a minimum role level. If not met, redirect with error.
 */
function require_role(int $min_level, string $redirect = 'index.php'): void {
    if (!has_role($min_level) || !is_active()) {
        $_SESSION['error_message'] = 'You do not have permission to access this page.';
        header("Location: $redirect");
        exit;
    }
}

/**
 * Require Super Admin role specifically for admin management pages.
 */
function require_super_admin(string $redirect = 'index.php'): void {
    if (!is_role('Super Admin') || !is_active()) {
        $_SESSION['error_message'] = 'Only Super Admins can access this page.';
        header("Location: $redirect");
        exit;
    }
}

/**
 * Human-readable list of role names for dropdowns.
 */
function get_all_roles(): array {
    return ['Super Admin', 'Admin', 'Manager', 'Staff'];
}

/**
 * Determine if a role can be assigned by the current admin.
 * Super Admin can assign any role.
 * Admin can only assign Admin, Manager, Staff (not Super Admin).
 */
function can_assign_role(string $target_role): bool {
    if (is_role('Super Admin')) {
        return true;
    }
    // Admin cannot assign Super Admin
    if ($target_role === 'Super Admin') {
        return false;
    }
    return is_role('Admin');
}
