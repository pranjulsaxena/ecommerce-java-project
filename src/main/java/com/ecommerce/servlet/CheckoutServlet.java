package com.ecommerce.servlet;

import com.ecommerce.dao.CartDAO;
import com.ecommerce.dao.OrderDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Cart;
import com.ecommerce.model.Order;
import com.ecommerce.model.Product;
import com.ecommerce.model.User;
import com.ecommerce.payment.PaymentInterface;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private CartDAO cartDAO;
    private OrderDAO orderDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        cartDAO = new CartDAO();
        orderDAO = new OrderDAO();
        productDAO = new ProductDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // 1. Retrieve the cart from the HttpSession
        @SuppressWarnings("unchecked")
        HashMap<Integer, Integer> cart = (HashMap<Integer, Integer>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart.jsp?error=Cart is empty");
            return;
        }

        String cardNumber = request.getParameter("cardNumber");
        if (cardNumber == null || cardNumber.trim().isEmpty()) {
            response.sendRedirect("checkout.jsp?error=Card number is required");
            return;
        }

        try {
            // 2. Calculate the total price
            double totalAmount = 0.0;
            Map<Integer, Product> productCache = new HashMap<>();

            for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                int productId = entry.getKey();
                int quantity = entry.getValue();

                Product product = productDAO.getProduct(productId);
                if (product != null) {
                    totalAmount += product.getPrice() * quantity;
                    productCache.put(productId, product); // Cache to use later for stock deduction
                }
            }

            if (totalAmount <= 0) {
                response.sendRedirect("cart.jsp?error=Invalid cart total");
                return;
            }

            // 3. Connect to the RMI 'PaymentService' on localhost:1099
            Registry registry = LocateRegistry.getRegistry("localhost", 1099);
            PaymentInterface paymentService = (PaymentInterface) registry.lookup("PaymentService");

            // 4. Call validatePayment with the card number
            boolean paymentSuccess = paymentService.validatePayment(cardNumber, totalAmount);

            // 5. If the payment is successful
            if (paymentSuccess) {
                // Deduct purchased items from inventory (as recommended earlier)
                for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                    int productId = entry.getKey();
                    int quantity = entry.getValue();
                    Product product = productCache.get(productId);
                    
                    if (product != null) {
                        int newStock = product.getStock() - quantity;
                        if (newStock < 0) newStock = 0; // Guard against negative stock
                        productDAO.updateStock(productId, newStock);
                    }
                }

                // Retrieve user from session if they are logged in
                User user = (User) session.getAttribute("user");

                // Use OrderDAO to save the order to the database
                Order newOrder = new Order(user, new Date(), totalAmount);
                orderDAO.saveOrder(newOrder);

                // Persist the cart details into the 'carts' table
                for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                    int productId = entry.getKey();
                    int quantity = entry.getValue();
                    Product product = productCache.get(productId);
                    if (product != null) {
                        Cart cartItem = new Cart(user, product, quantity);
                        cartDAO.saveCart(cartItem);
                    }
                }

                // Clear the session cart
                session.removeAttribute("cart");

                // 6. Redirect to 'success.jsp'
                response.sendRedirect("success.jsp");
            } else {
                // Payment failed
                response.sendRedirect("checkout.jsp?error=Payment validation failed. Please check your card details.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("checkout.jsp?error=An internal error occurred during checkout process.");
        }
    }
}
