package com.bookstore.controller;

import com.bookstore.model.user.*;
import com.bookstore.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
        model.addAttribute("pageTitle", "User Login - ReadVerse");
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
                return "redirect:/admin";
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
        model.addAttribute("pageTitle", "Register Account - ReadVerse");
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
        model.addAttribute("pageTitle", "My Profile - ReadVerse");
        model.addAttribute("membershipTypes", MembershipType.values());
        return "user/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@RequestParam("fullName") String fullName,
                                @RequestParam("email") String email,
                                @RequestParam("phoneNumber") String phoneNumber,
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
}
