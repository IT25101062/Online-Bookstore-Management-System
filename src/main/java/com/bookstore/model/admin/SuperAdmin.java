package com.bookstore.model.admin;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

/**
 * SuperAdmin – extends Admin.
 * Demonstrates Inheritance from Admin (and transitively from User).
 * Polymorphism: overrides getAdminType() and canManageAdmins().
 *
 * SuperAdmin has ALL permissions by default and can manage other admin accounts.
 *
 * @author IT25101062
 */
public class SuperAdmin extends Admin {

    private static final long serialVersionUID = 1L;

    private static final Set<String> FULL_PERMISSIONS = new HashSet<>(Arrays.asList(
        "MANAGE_BOOKS", "MANAGE_ORDERS", "MANAGE_USERS", "VIEW_REPORTS",
        "MANAGE_INVENTORY", "MANAGE_ADMINS"
    ));

    public SuperAdmin() {
        super();
        setPermissions(FULL_PERMISSIONS);
    }

    public SuperAdmin(String userId, String username, String password,
                      String fullName, String email, String phoneNumber, String createdAt) {
        super(userId, username, password, fullName, email, phoneNumber, FULL_PERMISSIONS, createdAt);
    }

    public SuperAdmin(String userId, String username, String password,
                      String fullName, String email, String phoneNumber,
                      Set<String> permissions, String createdAt) {
        super(userId, username, password, fullName, email, phoneNumber, permissions, createdAt);
    }

    /** Polymorphic override – returns type label */
    @Override
    public String getAdminType() {
        return "Super Admin";
    }

    /** Polymorphic override – super admins CAN manage other admins */
    @Override
    public boolean canManageAdmins() {
        return true;
    }

    /** Polymorphic override – extra strict auth for super admin */
    @Override
    public boolean authenticate(String inputPassword) {
        boolean ok = super.authenticate(inputPassword);
        if (ok) {
            System.out.println("[AUDIT] SuperAdmin authenticated: " + getUsername());
        }
        return ok;
    }
}
