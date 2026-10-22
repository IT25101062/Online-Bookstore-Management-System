package com.bookstore.model.admin;

import com.bookstore.util.FileStorageHelper;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * ActivityLog – Encapsulated audit record for admin actions.
 * Demonstrates Encapsulation: all fields are private with getters/setters only.
 *
 * File format (activity_logs.txt):
 *   logId|adminId|action|timestamp
 *
 * @author IT25101062
 */
public class ActivityLog implements Serializable {

    private static final long serialVersionUID = 1L;
    private static final DateTimeFormatter FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    // Encapsulated private fields
    private String logId;
    private String adminId;
    private String action;
    private String timestamp;

    public ActivityLog() {
        this.timestamp = LocalDateTime.now().format(FORMATTER);
    }

    public ActivityLog(String logId, String adminId, String action) {
        this.logId     = logId;
        this.adminId   = adminId;
        this.action    = action;
        this.timestamp = LocalDateTime.now().format(FORMATTER);
    }

    public ActivityLog(String logId, String adminId, String action, String timestamp) {
        this.logId     = logId;
        this.adminId   = adminId;
        this.action    = action;
        this.timestamp = (timestamp != null && !timestamp.isEmpty())
                         ? timestamp : LocalDateTime.now().format(FORMATTER);
    }

    // =========================================================================
    // Encapsulation – Getters and Setters (no direct field access)
    // =========================================================================

    public String getLogId()   { return logId; }
    public void   setLogId(String logId) { this.logId = logId; }

    public String getAdminId() { return adminId; }
    public void   setAdminId(String adminId) { this.adminId = adminId; }

    public String getAction()  { return action; }
    public void   setAction(String action) {
        if (action != null && !action.trim().isEmpty()) {
            this.action = action.trim();
        }
    }

    public String getTimestamp() { return timestamp; }
    public void   setTimestamp(String timestamp) { this.timestamp = timestamp; }

    /** Serialize to pipe-delimited line for activity_logs.txt */
    public String toFileRecord() {
        return FileStorageHelper.joinPipe(logId, adminId, action, timestamp);
    }

    @Override
    public String toString() {
        return "[" + timestamp + "] " + adminId + " → " + action;
    }
}
