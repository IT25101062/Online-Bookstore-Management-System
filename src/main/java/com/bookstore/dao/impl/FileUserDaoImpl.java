package com.bookstore.dao.impl;

import com.bookstore.dao.UserDao;
import com.bookstore.model.user.*;
import com.bookstore.util.FileStorageHelper;
import org.springframework.stereotype.Repository;

import java.util.*;
import java.util.stream.Collectors;

/**
 * File Handling implementation of UserDao reading from and writing to users.txt.
 * Satisfies the SE1020 File Handling requirement.
 * 
 * @author IT25101062
 */
@Repository
public class FileUserDaoImpl implements UserDao {

    private static final String FILENAME = "users.txt";
    private static final String HEADER = "userId|username|password|fullName|email|phoneNumber|role|membershipType|createdAt";

    @Override
    public synchronized boolean save(User user) {
        if (user == null || user.getUserId() == null) {
            return false;
        }
        return FileStorageHelper.appendLine(FILENAME, user.toFileRecord());
    }

    @Override
    public Optional<User> findById(String userId) {
        if (userId == null) return Optional.empty();
        return findAll().stream()
                .filter(u -> u.getUserId().equalsIgnoreCase(userId.trim()))
                .findFirst();
    }

    @Override
    public Optional<User> findByUsername(String username) {
        if (username == null) return Optional.empty();
        return findAll().stream()
                .filter(u -> u.getUsername().equalsIgnoreCase(username.trim()))
                .findFirst();
    }

    @Override
    public Optional<User> findByEmail(String email) {
        if (email == null) return Optional.empty();
        return findAll().stream()
                .filter(u -> u.getEmail().equalsIgnoreCase(email.trim()))
                .findFirst();
    }

    @Override
    public List<User> findAll() {
        List<String> lines = FileStorageHelper.readAllLines(FILENAME);
        List<User> users = new ArrayList<>();

        for (String line : lines) {
            if (line.toLowerCase().startsWith("userid|")) {
                continue; // Skip header line
            }
            User user = parseUser(line);
            if (user != null) {
                users.add(user);
            }
        }
        return users;
    }

    @Override
    public List<User> search(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll();
        }
        String term = keyword.trim().toLowerCase();
        return findAll().stream()
                .filter(u -> (u.getUsername() != null && u.getUsername().toLowerCase().contains(term))
                        || (u.getFullName() != null && u.getFullName().toLowerCase().contains(term))
                        || (u.getEmail() != null && u.getEmail().toLowerCase().contains(term))
                        || (u.getPhoneNumber() != null && u.getPhoneNumber().contains(term))
                        || (u.getUserId() != null && u.getUserId().toLowerCase().contains(term)))
                .collect(Collectors.toList());
    }

    @Override
    public synchronized boolean update(User updatedUser) {
        if (updatedUser == null || updatedUser.getUserId() == null) {
            return false;
        }

        List<User> allUsers = findAll();
        boolean found = false;
        List<String> updatedLines = new ArrayList<>();

        for (User u : allUsers) {
            if (u.getUserId().equalsIgnoreCase(updatedUser.getUserId())) {
                updatedLines.add(updatedUser.toFileRecord());
                found = true;
            } else {
                updatedLines.add(u.toFileRecord());
            }
        }

        if (found) {
            return FileStorageHelper.writeAllLines(FILENAME, HEADER, updatedLines);
        }
        return false;
    }

    @Override
    public synchronized boolean deleteById(String userId) {
        if (userId == null) return false;

        List<User> allUsers = findAll();
        int initialSize = allUsers.size();
        List<String> retainedLines = allUsers.stream()
                .filter(u -> !u.getUserId().equalsIgnoreCase(userId.trim()))
                .map(User::toFileRecord)
                .collect(Collectors.toList());

        if (retainedLines.size() < initialSize) {
            return FileStorageHelper.writeAllLines(FILENAME, HEADER, retainedLines);
        }
        return false;
    }

    @Override
    public synchronized String generateNextId() {
        List<User> users = findAll();
        int maxId = 0;
        for (User u : users) {
            String idStr = u.getUserId();
            if (idStr != null && idStr.toUpperCase().startsWith("U")) {
                try {
                    int num = Integer.parseInt(idStr.substring(1));
                    if (num > maxId) maxId = num;
                } catch (NumberFormatException ignored) {}
            }
        }
        return String.format("U%03d", maxId + 1);
    }

    /**
     * Factory method parsing a pipe-delimited text line into an AdminUser or CustomerUser.
     * Demonstrates Polymorphism and Object Instantiation.
     */
    private User parseUser(String line) {
        try {
            String[] tokens = FileStorageHelper.splitPipe(line);
            if (tokens.length < 7) {
                return null;
            }

            String userId = tokens[0].trim();
            String username = tokens[1].trim();
            String password = tokens[2].trim();
            String fullName = tokens[3].trim();
            String email = tokens[4].trim();
            String phoneNumber = tokens[5].trim();
            String roleStr = tokens[6].trim();
            String membershipStr = tokens.length > 7 ? tokens[7].trim() : "STANDARD";
            String createdAt = tokens.length > 8 ? tokens[8].trim() : "";

            UserRole role = UserRole.fromString(roleStr);

            if (role == UserRole.ADMIN) {
                return new AdminUser(userId, username, password, fullName, email, phoneNumber, createdAt);
            } else {
                MembershipType membership = MembershipType.fromString(membershipStr);
                return new CustomerUser(userId, username, password, fullName, email, phoneNumber, membership, createdAt);
            }
        } catch (Exception e) {
            System.err.println("Error parsing user line: " + line + " -> " + e.getMessage());
            return null;
        }
    }
}
