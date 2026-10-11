package com.bookstore.model.user;

import com.bookstore.util.FileStorageHelper;

/**
 * CustomerUser class extending User.
 * Demonstrates Inheritance, Polymorphic discount calculation, and role descriptions.
 * 
 * @author IT25101062
 */
public class CustomerUser extends User {

    private static final long serialVersionUID = 1L;

    private MembershipType membershipType = MembershipType.STANDARD;
    private int loyaltyPoints = 0;
    private String shippingAddress = "";

    public CustomerUser() {
        super();
        setRole(UserRole.CUSTOMER);
    }

    public CustomerUser(String userId, String username, String password, String fullName, String email, String phoneNumber, MembershipType membershipType) {
        super(userId, username, password, fullName, email, phoneNumber, UserRole.CUSTOMER);
        this.membershipType = (membershipType != null) ? membershipType : MembershipType.STANDARD;
    }

    public CustomerUser(String userId, String username, String password, String fullName, String email, String phoneNumber, MembershipType membershipType, String createdAt) {
        super(userId, username, password, fullName, email, phoneNumber, UserRole.CUSTOMER, createdAt);
        this.membershipType = (membershipType != null) ? membershipType : MembershipType.STANDARD;
    }

    @Override
    public String getRoleDescription() {
        return "Customer (" + membershipType.name() + " Member - " + (int)(getDiscountRate() * 100) + "% off)";
    }

    @Override
    public boolean hasAdminPrivileges() {
        return false;
    }

    @Override
    public double getDiscountRate() {
        return (membershipType != null) ? membershipType.getDiscountRate() : 0.0;
    }

    public MembershipType getMembershipType() {
        return membershipType;
    }

    public void setMembershipType(MembershipType membershipType) {
        this.membershipType = (membershipType != null) ? membershipType : MembershipType.STANDARD;
    }

    public int getLoyaltyPoints() {
        return loyaltyPoints;
    }

    public void setLoyaltyPoints(int loyaltyPoints) {
        this.loyaltyPoints = Math.max(0, loyaltyPoints);
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
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
            UserRole.CUSTOMER.name(),
            (membershipType != null ? membershipType.name() : MembershipType.STANDARD.name()),
            getCreatedAt()
        );
    }
}
