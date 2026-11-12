package com.bookstore.dao.impl;

import com.bookstore.dao.AdminDao;
import com.bookstore.model.admin.Admin;
import com.bookstore.model.admin.ActivityLog;
import com.bookstore.model.admin.ModeratorAdmin;
import com.bookstore.model.admin.SuperAdmin;
import com.bookstore.util.FileStorageHelper;
import org.springframework.stereotype.Repository;

import java.util.*;
import java.util.stream.Collectors;

/**
 * FileAdminDaoImpl – file-based Admin DAO implementation.
 * Reads/writes admins.txt and activity_logs.txt using FileStorageHelper.
 *
 * admins.txt format:
 *   adminId|username|email|password|permissions|createdDate
 *
 * activity_logs.txt format:
 *   logId|adminId|action|timestamp
 *
 * @author IT25101062
 */
@Repository
public class FileAdminDaoImpl implements AdminDao {

    private static final String ADMIN_FILE   = "admins.txt";
    private static final String LOG_FILE     = "activity_logs.txt";
    private static final String ADMIN_HEADER = "adminId|username|email|password|permissions|createdDate";
    private static final String LOG_HEADER   = "logId|adminId|action|timestamp";

    // =========================================================================
    // Admin CRUD
    // =========================================================================

    @Override
    public synchronized boolean saveAdmin(Admin admin) {
        if (admin == null || admin.getUserId() == null) return false;
        return FileStorageHelper.appendLine(ADMIN_FILE, admin.toFileRecord());
    }

    @Override
    public Optional<Admin> findAdminById(String adminId) {
        if (adminId == null) return Optional.empty();
        return findAllAdmins().stream()
               .filter(a -> a.getUserId().equalsIgnoreCase(adminId.trim()))
               .findFirst();
    }

    @Override
    public Optional<Admin> findAdminByUsername(String username) {
        if (username == null) return Optional.empty();
        return findAllAdmins().stream()
               .filter(a -> a.getUsername().equalsIgnoreCase(username.trim()))
               .findFirst();
    }

    @Override
    public List<Admin> findAllAdmins() {
        List<String> lines = FileStorageHelper.readAllLines(ADMIN_FILE);
        List<Admin>  admins = new ArrayList<>();
        for (String line : lines) {
            if (line.toLowerCase().startsWith("adminid|")) continue;
            Admin admin = parseAdmin(line);
            if (admin != null) admins.add(admin);
        }
        return admins;
    }

    @Override
    public List<Admin> searchAdmins(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) return findAllAdmins();
        String kw = keyword.trim().toLowerCase();
        return findAllAdmins().stream()
               .filter(a -> a.getUserId().toLowerCase().contains(kw)
                         || a.getUsername().toLowerCase().contains(kw)
                         || a.getEmail().toLowerCase().contains(kw))
               .collect(Collectors.toList());
    }

    @Override
    public synchronized boolean updateAdmin(Admin updated) {
        if (updated == null || updated.getUserId() == null) return false;
        List<Admin>  all   = findAllAdmins();
        boolean      found = false;
        List<String> lines = new ArrayList<>();
        for (Admin a : all) {
            if (a.getUserId().equalsIgnoreCase(updated.getUserId())) {
                lines.add(updated.toFileRecord());
                found = true;
            } else {
                lines.add(a.toFileRecord());
            }
        }
        return found && FileStorageHelper.writeAllLines(ADMIN_FILE, ADMIN_HEADER, lines);
    }

    @Override
    public synchronized boolean deleteAdminById(String adminId) {
        if (adminId == null) return false;
        List<Admin>  all     = findAllAdmins();
        int          before  = all.size();
        List<String> retained = all.stream()
            .filter(a -> !a.getUserId().equalsIgnoreCase(adminId.trim()))
            .map(Admin::toFileRecord)
            .collect(Collectors.toList());
        if (retained.size() < before) {
            return FileStorageHelper.writeAllLines(ADMIN_FILE, ADMIN_HEADER, retained);
        }
        return false;
    }

    @Override
    public synchronized String generateNextAdminId() {
        List<Admin> all = findAllAdmins();
        int max = 100;
        for (Admin a : all) {
            String id = a.getUserId();
            if (id != null && id.toUpperCase().startsWith("ADM")) {
                try {
                    int num = Integer.parseInt(id.substring(3));
                    if (num > max) max = num;
                } catch (NumberFormatException ignored) {}
            }
        }
        return String.format("ADM%03d", max + 1);
    }

    // =========================================================================
    // Activity Log
    // =========================================================================

    @Override
    public synchronized boolean saveLog(ActivityLog log) {
        if (log == null || log.getLogId() == null) return false;
        return FileStorageHelper.appendLine(LOG_FILE, log.toFileRecord());
    }

    @Override
    public List<ActivityLog> findAllLogs() {
        List<String>     lines = FileStorageHelper.readAllLines(LOG_FILE);
        List<ActivityLog> logs = new ArrayList<>();
        for (String line : lines) {
            if (line.toLowerCase().startsWith("logid|")) continue;
            ActivityLog log = parseLog(line);
            if (log != null) logs.add(log);
        }
        // Most-recent first
        Collections.reverse(logs);
        return logs;
    }

    @Override
    public List<ActivityLog> findLogsByAdminId(String adminId) {
        if (adminId == null) return Collections.emptyList();
        return findAllLogs().stream()
               .filter(l -> l.getAdminId().equalsIgnoreCase(adminId.trim()))
               .collect(Collectors.toList());
    }

    @Override
    public synchronized String generateNextLogId() {
        List<ActivityLog> logs = findAllLogs();
        int max = 0;
        for (ActivityLog l : logs) {
            String id = l.getLogId();
            if (id != null && id.toUpperCase().startsWith("LOG")) {
                try {
                    int num = Integer.parseInt(id.substring(3));
                    if (num > max) max = num;
                } catch (NumberFormatException ignored) {}
            }
        }
        return String.format("LOG%05d", max + 1);
    }

    // =========================================================================
    // Parsers
    // =========================================================================

    private Admin parseAdmin(String line) {
        try {
            String[] t = FileStorageHelper.splitPipe(line);
            if (t.length < 6) return null;

            String adminId    = t[0].trim();
            String username   = t[1].trim();
            String email      = t[2].trim();
            String password   = t[3].trim();
            String permStr    = t[4].trim();
            String createdAt  = t[5].trim();

            // Determine type by permissions: if has MANAGE_ADMINS → SuperAdmin
            boolean isSuperAdmin = permStr.contains("MANAGE_ADMINS");

            Admin admin;
            Set<String> perms = new HashSet<>();
            if (!permStr.isEmpty()) {
                Arrays.stream(permStr.split(";"))
                      .map(String::trim)
                      .filter(s -> !s.isEmpty())
                      .forEach(perms::add);
            }

            String fullName = username.equalsIgnoreCase("superadmin") ? "Super Administrator" : username;

            if (isSuperAdmin) {
                admin = new SuperAdmin(adminId, username, password,
                                       fullName, email, "", perms, createdAt);
            } else {
                admin = new ModeratorAdmin(adminId, username, password,
                                           fullName, email, "", perms, createdAt);
            }
            admin.setEmail(email);
            return admin;
        } catch (Exception e) {
            System.err.println("Error parsing admin line: " + line + " -> " + e.getMessage());
            return null;
        }
    }

    private ActivityLog parseLog(String line) {
        try {
            String[] t = FileStorageHelper.splitPipe(line);
            if (t.length < 4) return null;
            return new ActivityLog(t[0].trim(), t[1].trim(), t[2].trim(), t[3].trim());
        } catch (Exception e) {
            System.err.println("Error parsing log line: " + line + " -> " + e.getMessage());
            return null;
        }
    }
}
