package com.bookstore.service.impl;

import com.bookstore.dao.AdminDao;
import com.bookstore.model.admin.*;
import com.bookstore.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * AdminServiceImpl – business logic for Admin Management.
 * Demonstrates Abstraction (hides DAO details) and OOP across
 * SuperAdmin/ModeratorAdmin.
 * Every mutating operation appends an ActivityLog entry automatically.
 *
 * @author IT25101062
 */
@Service
public class AdminServiceImpl implements AdminService {

    private final AdminDao adminDao;

    @Autowired
    public AdminServiceImpl(AdminDao adminDao) {
        this.adminDao = adminDao;
    }

    // =========================================================================
    // Create
    // =========================================================================

    @Override
    public Admin registerAdmin(String callerAdminId, String username, String password,
            String email, String adminType, Set<String> permissions) {

        // Only a SuperAdmin can register new admins
        Optional<Admin> callerOpt = adminDao.findAdminById(callerAdminId);
        if (callerOpt.isEmpty() || !((Admin) callerOpt.get()).canManageAdmins()) {
            throw new SecurityException("Only Super Admins can register new admin accounts.");
        }

        // Validate uniqueness
        if (adminDao.findAdminByUsername(username).isPresent()) {
            throw new IllegalArgumentException("Username '" + username + "' is already taken.");
        }

        String adminId = adminDao.generateNextAdminId();
        Admin newAdmin;

        if ("SUPER".equalsIgnoreCase(adminType)) {
            newAdmin = new SuperAdmin(adminId, username, password, username, email, "", permissions, null);
        } else {
            newAdmin = new ModeratorAdmin(adminId, username, password, username, email, "", permissions, null);
        }
        newAdmin.setEmail(email);

        if (!adminDao.saveAdmin(newAdmin)) {
            throw new RuntimeException("Failed to persist admin account.");
        }

        log(callerAdminId, "REGISTER_ADMIN: " + adminId + " (" + username + ") as " + newAdmin.getAdminType());
        return newAdmin;
    }

    // =========================================================================
    // Read
    // =========================================================================

    @Override
    public List<Admin> getAllAdmins() {
        return adminDao.findAllAdmins();
    }

    @Override
    public List<Admin> searchAdmins(String keyword) {
        return adminDao.searchAdmins(keyword);
    }

    @Override
    public Optional<Admin> getAdminById(String adminId) {
        return adminDao.findAdminById(adminId);
    }

    @Override
    public List<ActivityLog> getActivityLog() {
        return adminDao.findAllLogs();
    }

    @Override
    public List<ActivityLog> getActivityLogByAdmin(String adminId) {
        return adminDao.findLogsByAdminId(adminId);
    }

    // =========================================================================
    // Update
    // =========================================================================

    @Override
    public boolean updateAdmin(String callerAdminId, String targetAdminId,
            String newEmail, String newPassword, Set<String> newPermissions) {

        Optional<Admin> targetOpt = adminDao.findAdminById(targetAdminId);
        if (targetOpt.isEmpty())
            return false;

        Admin target = targetOpt.get();

        if (newEmail != null && newEmail.contains("@")) {
            target.setEmail(newEmail.trim());
        }
        if (newPassword != null && newPassword.trim().length() >= 6) {
            target.setPassword(newPassword.trim());
        }
        if (newPermissions != null && !newPermissions.isEmpty()) {
            target.setPermissions(newPermissions);
        }

        boolean ok = adminDao.updateAdmin(target);
        if (ok) {
            log(callerAdminId, "UPDATE_ADMIN: " + targetAdminId + " by " + callerAdminId);
        }
        return ok;
    }

    // =========================================================================
    // Delete
    // =========================================================================

    @Override
    public boolean deleteAdmin(String callerAdminId, String targetAdminId) {
        if (callerAdminId.equalsIgnoreCase(targetAdminId)) {
            throw new IllegalArgumentException("A super admin cannot delete their own account.");
        }

        // Check caller has permission
        Optional<Admin> callerOpt = adminDao.findAdminById(callerAdminId);
        if (callerOpt.isEmpty() || !callerOpt.get().canManageAdmins()) {
            throw new SecurityException("Only Super Admins can delete admin accounts.");
        }

        boolean ok = adminDao.deleteAdminById(targetAdminId);
        if (ok) {
            log(callerAdminId, "DELETE_ADMIN: " + targetAdminId + " by " + callerAdminId);
        }
        return ok;
    }

    // =========================================================================
    // Auth
    // =========================================================================

    @Override
    public Optional<Admin> authenticate(String username, String password) {
        Optional<Admin> adminOpt = adminDao.findAdminByUsername(username);
        if (adminOpt.isPresent() && adminOpt.get().authenticate(password)) {
            log(adminOpt.get().getUserId(), "LOGIN: " + username);
            return adminOpt;
        }
        return Optional.empty();
    }

    // =========================================================================
    // Private Helper
    // =========================================================================

    private void log(String adminId, String action) {
        String logId = adminDao.generateNextLogId();
        ActivityLog entry = new ActivityLog(logId, adminId, action);
        adminDao.saveLog(entry);
    }
}
