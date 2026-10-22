package com.bookstore.model.admin;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

/**
 * ModeratorAdmin – extends Admin.
 * Demonstrates Inheritance from Admin (and transitively from User).
 * Polymorphism: overrides getAdminType() and canManageAdmins().
 *
 * Moderators have limited permissions and CANNOT manage other admin accounts.
 *
 * @author IT25101062
 */
public class ModeratorAdmin extends Admin {

    private static final long serialVersionUID = 1L;

    private static final Set<String> DEFAULT_PERMISSIONS = new HashSet<>(Arrays.asList(
        "MANAGE_BOOKS", "MANAGE_ORDERS", "VIEW_REPORTS"
    ));

    public ModeratorAdmin() {
        super();
        setPermissions(DEFAULT_PERMISSIONS);
    }

    public ModeratorAdmin(String userId, String username, String password,
                          String fullName, String email, String phoneNumber, String createdAt) {
        super(userId, username, password, fullName, email, phoneNumber, DEFAULT_PERMISSIONS, createdAt);
    }

    public ModeratorAdmin(String userId, String username, String password,
                          String fullName, String email, String phoneNumber,
                          Set<String> permissions, String createdAt) {
        super(userId, username, password, fullName, email, phoneNumber, permissions, createdAt);
    }

    /** Polymorphic override – returns type label */
    @Override
    public String getAdminType() {
        return "Moderator";
    }

    /** Polymorphic override – moderators CANNOT manage other admins */
    @Override
    public boolean canManageAdmins() {
        return false;
    }

    @Override
    public boolean authenticate(String inputPassword) {
        boolean ok = super.authenticate(inputPassword);
        if (ok) {
            System.out.println("[AUDIT] Moderator authenticated: " + getUsername());
        }
        return ok;
    }
}
