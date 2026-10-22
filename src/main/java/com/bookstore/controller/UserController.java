package com.bookstore.controller;

import com.bookstore.model.user.*;
import com.bookstore.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Optional;

/**
 * Controller handling User Management CRUD operations and authentication.
 * 
 * CRUD Operations:
 * 1. Create: /register (register new user)
 * 2. Read  : /users (list all users, admin view), /profile (view user profile)
 * 3. Update: /profile/update (modify user details)
 * 4. Delete: /users/delete (remove user account)
 * 
 * @author IT25101062
 */
@Controller
public class UserController {

    private final UserService userService;

    @Value("${app.profile.upload.dir:src/main/resources/static/images/profiles}")
    private String profileUploadDir;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    // =========================================================================
    // Login & Logout
    // =========================================================================

    @GetMapping("/login")
    public String showLoginForm(HttpSession session, Model model) {
        if (session.getAttribute("currentUser") != null) {
            return "redirect:/";
        }
        model.addAttribute("pageTitle", "User Login - Chapter One");
        return "user/login";
    }

    @PostMapping("/login")
    public String processLogin(@RequestParam("username") String username,
                               @RequestParam("password") String password,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        Optional<User> authenticatedUser = userService.authenticate(username, password);

        if (authenticatedUser.isPresent()) {
            User user = authenticatedUser.get();
            session.setAttribute("currentUser", user);
            redirectAttributes.addFlashAttribute("successMessage", 
                "Welcome back, " + user.getFullName() + "! Logged in as " + user.getRoleDescription());

            if (user.hasAdminPrivileges()) {
                return "redirect:/admin/dashboard";
            }
            return "redirect:/";
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid username or password. Please try again.");
            return "redirect:/login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        session.invalidate();
        redirectAttributes.addFlashAttribute("infoMessage", "You have been logged out successfully.");
        return "redirect:/login";
    }

    // =========================================================================
    // Create: User Registration
    // =========================================================================

    @GetMapping("/register")
    public String showRegistrationForm(HttpSession session, Model model) {
        if (session.getAttribute("currentUser") != null) {
            return "redirect:/";
        }
        model.addAttribute("pageTitle", "Register Account - Chapter One");
        model.addAttribute("membershipTypes", MembershipType.values());
        return "user/register";
    }

    @PostMapping("/register")
    public String processRegistration(@RequestParam("username") String username,
                                      @RequestParam("password") String password,
                                      @RequestParam("fullName") String fullName,
                                      @RequestParam("email") String email,
                                      @RequestParam("phoneNumber") String phoneNumber,
                                      @RequestParam(value = "membershipType", defaultValue = "STANDARD") String membershipType,
                                      RedirectAttributes redirectAttributes) {
        try {
            CustomerUser newUser = new CustomerUser(
                null, 
                username, 
                password, 
                fullName, 
                email, 
                phoneNumber, 
                MembershipType.fromString(membershipType)
            );

            userService.register(newUser);
            redirectAttributes.addFlashAttribute("successMessage", 
                "Registration successful for " + username + "! You can now sign in.");
            return "redirect:/login";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/register";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Registration failed: " + e.getMessage());
            return "redirect:/register";
        }
    }

    // =========================================================================
    // Read & Update: User Profile
    // =========================================================================

    @GetMapping("/profile")
    public String showProfile(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        // Fetch fresh copy from file storage
        Optional<User> freshUser = userService.getUserById(currentUser.getUserId());
        if (freshUser.isPresent()) {
            currentUser = freshUser.get();
            session.setAttribute("currentUser", currentUser);
        }

        model.addAttribute("user", currentUser);
        model.addAttribute("pageTitle", "My Profile - Chapter One");
        model.addAttribute("membershipTypes", MembershipType.values());
        return "user/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@RequestParam("fullName") String fullName,
                                @RequestParam("email") String email,
                                @RequestParam("phoneNumber") String phoneNumber,
                                @RequestParam(value = "newUsername", required = false) String newUsername,
                                @RequestParam(value = "password", required = false) String password,
                                @RequestParam(value = "membershipType", required = false) String membershipType,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        try {
            currentUser.setFullName(fullName);
            currentUser.setEmail(email);
            currentUser.setPhoneNumber(phoneNumber);

            // Username change validation
            if (newUsername != null && !newUsername.trim().isEmpty()) {
                String trimmedUsername = newUsername.trim().toLowerCase().replaceAll("\\s+", "_");
                if (trimmedUsername.length() < 3) {
                    redirectAttributes.addFlashAttribute("errorMessage", "Username must be at least 3 characters.");
                    return "redirect:/profile";
                }
                if (!trimmedUsername.matches("[a-zA-Z0-9_\\.]+")) {
                    redirectAttributes.addFlashAttribute("errorMessage", "Username may only contain letters, numbers, underscores, and dots.");
                    return "redirect:/profile";
                }
                if (userService.isUsernameTaken(trimmedUsername, currentUser.getUserId())) {
                    redirectAttributes.addFlashAttribute("errorMessage", "Username '" + trimmedUsername + "' is already taken. Please choose another.");
                    return "redirect:/profile";
                }
                currentUser.setUsername(trimmedUsername);
            }

            if (password != null && !password.trim().isEmpty() && password.trim().length() >= 6) {
                currentUser.setPassword(password.trim());
            }

            if (currentUser instanceof CustomerUser && membershipType != null) {
                ((CustomerUser) currentUser).setMembershipType(MembershipType.fromString(membershipType));
            }

            boolean updated = userService.updateProfile(currentUser);
            if (updated) {
                session.setAttribute("currentUser", currentUser);
                redirectAttributes.addFlashAttribute("successMessage", "Profile updated successfully!");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Failed to update profile in data file.");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating profile: " + e.getMessage());
        }

        return "redirect:/profile";
    }

    // =========================================================================
    // Read: User List & Search (Admin View)
    // =========================================================================

    @GetMapping("/users")
    public String listUsers(@RequestParam(value = "keyword", required = false) String keyword,
                            HttpSession session,
                            Model model,
                            RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !currentUser.hasAdminPrivileges()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Access Denied: Administrator privileges required.");
            return "redirect:/login";
        }

        List<User> users = (keyword != null && !keyword.trim().isEmpty())
                ? userService.searchUsers(keyword)
                : userService.getAllUsers();

        model.addAttribute("users", users);
        model.addAttribute("keyword", keyword);
        model.addAttribute("pageTitle", "User Management - Admin View");
        return "user/user-list";
    }

    // =========================================================================
    // Delete: Remove User Account (Admin View)
    // =========================================================================

    @PostMapping("/users/delete")
    public String deleteUser(@RequestParam("userId") String userId,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !currentUser.hasAdminPrivileges()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Access Denied: Administrator privileges required.");
            return "redirect:/login";
        }

        if (currentUser.getUserId().equalsIgnoreCase(userId)) {
            redirectAttributes.addFlashAttribute("errorMessage", "Cannot delete your own currently logged-in account!");
            return "redirect:/users";
        }

        boolean deleted = userService.deleteUser(userId);
        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "User account " + userId + " was deleted successfully.");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to delete user " + userId + " (protected system account).");
        }

        return "redirect:/users";
    }

    // =========================================================================
    // Profile Picture Upload
    // =========================================================================

    @PostMapping("/profile/upload-picture")
    public String uploadProfilePicture(@RequestParam("profilePic") MultipartFile file,
                                       HttpSession session,
                                       RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        if (file == null || file.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Please choose an image file to upload.");
            return "redirect:/profile";
        }

        // Validate file type
        String contentType = file.getContentType();
        if (contentType == null || (!contentType.equals("image/jpeg") &&
                !contentType.equals("image/png") && !contentType.equals("image/gif") &&
                !contentType.equals("image/webp"))) {
            redirectAttributes.addFlashAttribute("errorMessage", "Only JPG, PNG, GIF, or WEBP images are allowed.");
            return "redirect:/profile";
        }

        // Validate file size (max 5MB)
        if (file.getSize() > 5 * 1024 * 1024) {
            redirectAttributes.addFlashAttribute("errorMessage", "Image must be under 5MB.");
            return "redirect:/profile";
        }

        try {
            // Determine extension from original filename or content type
            String originalName = file.getOriginalFilename();
            String ext = ".jpg";
            if (originalName != null && originalName.contains(".")) {
                ext = originalName.substring(originalName.lastIndexOf(".")).toLowerCase();
            } else if ("image/png".equals(contentType)) {
                ext = ".png";
            } else if ("image/gif".equals(contentType)) {
                ext = ".gif";
            } else if ("image/webp".equals(contentType)) {
                ext = ".webp";
            }

            String filename = currentUser.getUserId() + ext;

            // Save to source directory
            File uploadDir = new File(profileUploadDir);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            Path dest = Paths.get(profileUploadDir, filename);
            Files.copy(file.getInputStream(), dest, StandardCopyOption.REPLACE_EXISTING);

            // Also copy to target/classes so Spring Boot serves it immediately without restart
            String targetDir = "target/classes/static/images/profiles";
            File targetDirFile = new File(targetDir);
            if (!targetDirFile.exists()) {
                targetDirFile.mkdirs();
            }
            Path targetDest = Paths.get(targetDir, filename);
            Files.copy(file.getInputStream(), targetDest, StandardCopyOption.REPLACE_EXISTING);

            // Update user session with the new picture filename
            currentUser.setProfilePicture(filename);
            session.setAttribute("currentUser", currentUser);

            redirectAttributes.addFlashAttribute("successMessage", "Profile picture updated successfully!");
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to upload picture: " + e.getMessage());
        }

        return "redirect:/profile";
    }
}
