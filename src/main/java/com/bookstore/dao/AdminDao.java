package com.bookstore.dao;

import com.bookstore.model.admin.Admin;
import com.bookstore.model.admin.ActivityLog;

import java.util.List;
import java.util.Optional;

/**
 * AdminDao – Data Access Object interface for Admin Management.
 * Defines all file I/O operations for admins.txt and activity_logs.txt.
 *
 * @author IT25101062
 */
public interface AdminDao {

    // ---- Admin CRUD ----

    /** Persist a new admin record */
    boolean saveAdmin(Admin admin);

    /** Find admin by ID */
    Optional<Admin> findAdminById(String adminId);

    /** Find admin by username */
    Optional<Admin> findAdminByUsername(String username);

    /** Return all admin records */
    List<Admin> findAllAdmins();

    /** Search admins by username or ID keyword */
    List<Admin> searchAdmins(String keyword);

    /** Update an existing admin record */
    boolean updateAdmin(Admin updatedAdmin);

    /** Delete an admin record by ID */
    boolean deleteAdminById(String adminId);

    /** Generate next admin ID */
    String generateNextAdminId();

    // ---- Activity Log ----

    /** Append an activity log entry */
    boolean saveLog(ActivityLog log);

    /** Return all log entries */
    List<ActivityLog> findAllLogs();

    /** Return log entries for a specific admin */
    List<ActivityLog> findLogsByAdminId(String adminId);

    /** Generate next log entry ID */
    String generateNextLogId();
}
