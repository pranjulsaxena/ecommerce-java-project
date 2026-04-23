package com.ecommerce.test;

import com.ecommerce.dao.*;
import com.ecommerce.model.*;
import java.util.Date;
import java.util.List;

public class IntegrationTest {
    public static void main(String[] args) {
        System.out.println("=== E-Commerce Integration Test ===\n");
        
        try {
            // Test 1: Create and retrieve users
            System.out.println("TEST 1: Testing UserDAO...");
            UserDAO userDAO = new UserDAO();
            
            User testUser = new User("John Doe", "john@example.com", "password123");
            userDAO.saveUser(testUser);
            System.out.println("✓ User created: " + testUser.getName());
            
            List<User> allUsers = userDAO.getAllUsers();
            System.out.println("✓ Total users in DB: " + allUsers.size());
            
            // Test 2: Create and retrieve products
            System.out.println("\nTEST 2: Testing ProductDAO...");
            ProductDAO productDAO = new ProductDAO();
            
            Product laptop = new Product("Laptop", "High-performance laptop", 999.99, 10);
            productDAO.saveProduct(laptop);
            System.out.println("✓ Product created: " + laptop.getName());
            
            Product phone = new Product("Smartphone", "Latest smartphone", 699.99, 25);
            productDAO.saveProduct(phone);
            System.out.println("✓ Product created: " + phone.getName());
            
            List<Product> allProducts = productDAO.getAllProducts();
            System.out.println("✓ Total products in DB: " + allProducts.size());
            
            // Get the IDs for testing
            if (allProducts.size() >= 2) {
                Product p1 = allProducts.get(allProducts.size() - 2);
                Product p2 = allProducts.get(allProducts.size() - 1);
                
                // Test 3: Cart operations
                System.out.println("\nTEST 3: Testing CartDAO...");
                CartDAO cartDAO = new CartDAO();
                User u = allUsers.get(allUsers.size() - 1);
                
                Cart cartItem1 = new Cart(u, p1, 2);
                cartDAO.saveCart(cartItem1);
                System.out.println("✓ Added to cart: " + p1.getName() + " x2");
                
                Cart cartItem2 = new Cart(u, p2, 1);
                cartDAO.saveCart(cartItem2);
                System.out.println("✓ Added to cart: " + p2.getName() + " x1");
                
                List<Cart> userCart = cartDAO.getAllCarts();
                System.out.println("✓ Total cart items in DB: " + userCart.size());
                
                // Test 4: Order creation
                System.out.println("\nTEST 4: Testing OrderDAO...");
                OrderDAO orderDAO = new OrderDAO();
                
                double totalAmount = (p1.getPrice() * 2) + (p2.getPrice() * 1);
                Order order = new Order(u, new Date(), totalAmount);
                orderDAO.saveOrder(order);
                System.out.println("✓ Order created for user: " + u.getName());
                System.out.println("✓ Order total: $" + String.format("%.2f", totalAmount));
                
                List<Order> allOrders = orderDAO.getAllOrders();
                System.out.println("✓ Total orders in DB: " + allOrders.size());
                
                // Test 5: Stock deduction
                System.out.println("\nTEST 5: Testing Stock Update...");
                int oldStock = p1.getStock();
                productDAO.updateStock(p1.getId(), oldStock - 2);
                Product updatedProduct = productDAO.getProduct(p1.getId());
                System.out.println("✓ Stock updated: " + p1.getName());
                System.out.println("  Before: " + oldStock + " | After: " + updatedProduct.getStock());
                
                // Test 6: Login verification
                System.out.println("\nTEST 6: Testing Login Verification...");
                boolean validLogin = userDAO.verifyLogin("john@example.com", "password123");
                System.out.println("✓ Valid login check: " + (validLogin ? "PASSED" : "FAILED"));
                
                boolean invalidLogin = userDAO.verifyLogin("john@example.com", "wrongpassword");
                System.out.println("✓ Invalid login check: " + (invalidLogin ? "FAILED" : "PASSED"));
            }
            
            System.out.println("\n=== ALL TESTS COMPLETED SUCCESSFULLY ===");
            
        } catch (Exception e) {
            System.err.println("ERROR during integration test:");
            e.printStackTrace();
        }
    }
}
