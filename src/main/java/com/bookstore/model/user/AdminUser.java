package com.bookstore.model.user;

import com.bookstore.util.FileStorageHelper;

/**
 * AdminUser class extending User.
 * Demonstrates Inheritance and Polymorphism.
 * 
 * @author IT25101062
 */
public class AdminUser extends User {

    private static final long serialVersionUID = 1L;

    private String adminLevel = "SYSTEM_ADMIN";
    private String department = "Management";

    public AdminUser() {
        super();
        setRole(UserRole.ADMIN);
    }

    public AdminUser(String userId, String username, String password, String fullName, String email, String phoneNumber) {
        super(userId, username, password, fullName, email, phoneNumber, UserRole.ADMIN);
    }

    public AdminUser(String userId, String username, String password, String fullName, String email, String phoneNumber, String createdAt) {
        super(userId, username, password, fullName, email, phoneNumber, UserRole.ADMIN, createdAt);
    }

    @Override
    public String getRoleDescription() {
        return "System Administrator (Full CRUD Access)";
    }

    @Override
    public boolean hasAdminPrivileges() {
        return true;
    }

    @Override
    public double getDiscountRate() {
        return 0.15; // 15% staff discount
    }

    @Override
    public boolean authenticate(String inputPassword) {
        // Enforce administrative audit requirement: strict password check
        boolean authenticated = super.authenticate(inputPassword);
        if (authenticated) {
            System.out.println("[AUDIT LOG] Admin user authenticated: " + getUsername());
        }
        return authenticated;
    }

    public String getAdminLevel() {
        return adminLevel;
    }

    public void setAdminLevel(String adminLevel) {
        this.adminLevel = adminLevel;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    @Override
    public String toFileRecord() {
        return FileStorageHelper.joinPipe(
            getUserId(),
            getUsername(),
            getPassword(),
            getFullName(),
            getEmail(),
            getPhoneNumber(),
            UserRole.ADMIN.name(),
            "NONE",
            getCreatedAt()
        );
    }
}
