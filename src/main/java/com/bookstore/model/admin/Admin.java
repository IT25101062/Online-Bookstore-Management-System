package com.bookstore.model.admin;

import com.bookstore.model.user.User;
import com.bookstore.model.user.UserRole;
import com.bookstore.util.FileStorageHelper;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Abstract Admin base class extending User.
 * Demonstrates Inheritance (from User) and Abstraction (abstract permission check).
 *
 * File format (admins.txt):
 *   adminId|username|email|password|permissions|createdDate
 *   Example permissions: MANAGE_BOOKS;MANAGE_ORDERS;MANAGE_USERS;VIEW_REPORTS
 *
 * @author IT25101062
 */
public abstract class Admin extends User {

    private static final long serialVersionUID = 1L;

    // Encapsulated permission set – private with controlled getter/setter
    private Set<String> permissions;

    protected Admin() {
        super();
        setRole(UserRole.ADMIN);
        this.permissions = new HashSet<>();
    }

    protected Admin(String userId, String username, String password,
                    String fullName, String email, String phoneNumber,
                    Set<String> permissions, String createdAt) {
        super(userId, username, password, fullName, email, phoneNumber, UserRole.ADMIN, createdAt);
        this.permissions = permissions != null ? new HashSet<>(permissions) : new HashSet<>();
    }

    // =========================================================================
    // Encapsulation – private permissions with controlled access
    // =========================================================================

    public Set<String> getPermissions() {
        return Collections.unmodifiableSet(permissions);
    }

    public void setPermissions(Set<String> permissions) {
        this.permissions = permissions != null ? new HashSet<>(permissions) : new HashSet<>();
    }

    public void setPermissionsFromString(String permStr) {
        this.permissions = new HashSet<>();
        if (permStr != null && !permStr.trim().isEmpty()) {
            Arrays.stream(permStr.split(";"))
                  .map(String::trim)
                  .filter(s -> !s.isEmpty())
                  .forEach(this.permissions::add);
        }
    }

    public String getPermissionsAsString() {
        return permissions.stream().sorted().collect(Collectors.joining(";"));
    }

    /** Check if this admin holds a specific permission key */
    public boolean hasPermission(String permission) {
        return permissions.contains(permission);
    }

    // =========================================================================
    // Abstract – subclasses define their own admin type behaviour
    // =========================================================================

    /** Returns the type label, e.g. "Super Admin" or "Moderator" */
    public abstract String getAdminType();

    /** Returns whether this admin can create/delete other admin accounts */
    public abstract boolean canManageAdmins();

    // =========================================================================
    // Polymorphic overrides from User
    // =========================================================================

    @Override
    public boolean hasAdminPrivileges() {
        return true;
    }

    @Override
    public double getDiscountRate() {
        return 0.20; // 20% staff discount
    }

    @Override
    public String getRoleDescription() {
        return getAdminType() + " | Permissions: " + getPermissionsAsString();
    }

    @Override
    public String toFileRecord() {
        return FileStorageHelper.joinPipe(
            getUserId(),
            getUsername(),
            getEmail(),
            getPassword(),
            getPermissionsAsString(),
            getCreatedAt()
        );
    }
}
