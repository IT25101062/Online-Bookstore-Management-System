package com.bookstore.service;

import com.bookstore.model.admin.Admin;
import com.bookstore.model.admin.ActivityLog;

import java.util.List;
import java.util.Optional;
import java.util.Set;

/**
 * AdminService interface for Admin Management CRUD operations.
 *
 * CRUD:
 * - Create : registerAdmin (super-admin only)
 * - Read   : getAllAdmins, searchAdmins, getActivityLog
 * - Update : updateAdmin (email, password, permissions)
 * - Delete : deleteAdmin (cannot self-delete)
 *
 * Every Create/Update/Delete action logs to activity_logs.txt automatically.
 *
 * @author IT25101062
 */
public interface AdminService {

    /** Create – register a new admin (only callable by a super admin) */
    Admin registerAdmin(String callerAdminId, String username, String password,
                        String email, String adminType, Set<String> permissions);

    /** Read – get all admins */
    List<Admin> getAllAdmins();

    /** Read – search by username or ID */
    List<Admin> searchAdmins(String keyword);

    /** Read – get a single admin */
    Optional<Admin> getAdminById(String adminId);

    /** Read – get activity log (all entries) */
    List<ActivityLog> getActivityLog();

    /** Read – get activity log filtered to one admin */
    List<ActivityLog> getActivityLogByAdmin(String adminId);

    /** Update – edit email, password and/or permissions */
    boolean updateAdmin(String callerAdminId, String targetAdminId,
                        String newEmail, String newPassword, Set<String> newPermissions);

    /** Delete – remove admin account (caller cannot delete themselves) */
    boolean deleteAdmin(String callerAdminId, String targetAdminId);

    /** Authenticate – verify admin credentials (returns empty if invalid) */
    Optional<Admin> authenticate(String username, String password);
}
