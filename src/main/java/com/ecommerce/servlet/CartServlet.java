package com.ecommerce.servlet;

import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;

@WebServlet("/addToCart")
public class CartServlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        // Initialize ProductDAO
        productDAO = new ProductDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve productId and quantity from request parameters
        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");

        // Validate that both parameters are present
        if (productIdStr == null || quantityStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Product ID and Quantity are required.");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            int quantity = Integer.parseInt(quantityStr);

            // Validate quantity is positive
            if (quantity <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quantity must be greater than zero.");
                return;
            }

            // Use ProductDAO to verify that the product exists before adding to cart
            Product product = productDAO.getProduct(productId);
            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found in the database.");
                return;
            }

            // Retrieve the HttpSession
            HttpSession session = request.getSession();

            // Retrieve or create the cart HashMap from the session
            @SuppressWarnings("unchecked")
            HashMap<Integer, Integer> cart = (HashMap<Integer, Integer>) session.getAttribute("cart");
            if (cart == null) {
                cart = new HashMap<>();
            }

            // Add the item to the cart (or update quantity if already exists)
            cart.put(productId, cart.getOrDefault(productId, 0) + quantity);

            // Store the cart back in the session
            session.setAttribute("cart", cart);

            // Redirect to products.jsp
            response.sendRedirect("products.jsp");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Product ID or Quantity format.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An internal error occurred.");
        }
    }
}
