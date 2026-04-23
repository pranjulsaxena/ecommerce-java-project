<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.ecommerce.dao.ProductDAO" %>
<%@ page import="com.ecommerce.model.Product" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Shopping Cart</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body { 
            background-color: #f8f9fa; 
            padding: 40px 0;
        }
        .container { 
            max-width: 900px; 
            background: white; 
            padding: 30px; 
            border-radius: 8px; 
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        h2 { 
            border-bottom: 3px solid #007bff; 
            padding-bottom: 15px; 
            margin-bottom: 30px;
            color: #333;
        }
        .cart-table {
            margin-bottom: 30px;
        }
        .cart-table thead {
            background-color: #f1f3f5;
        }
        .cart-table th {
            font-weight: 600;
            color: #333;
            border-bottom: 2px solid #dee2e6;
        }
        .total-row {
            font-size: 18px;
            font-weight: 600;
            color: #d9534f;
        }
        .checkout-section { 
            display: none;
            margin-top: 30px; 
            padding: 25px; 
            border: 2px solid #007bff; 
            background-color: #e7f3ff; 
            border-radius: 6px;
        }
        .checkout-section.show {
            display: block;
        }
        .btn { 
            border-radius: 4px; 
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-success { 
            background-color: #28a745;
            border-color: #28a745;
        }
        .btn-success:hover { 
            background-color: #218838;
            border-color: #1e7e34;
        }
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0051a0;
        }
        .alert-danger {
            border-radius: 4px;
            margin-bottom: 20px;
        }
        .form-group input {
            border-radius: 4px;
            border: 1px solid #ccc;
            padding: 10px;
        }
        .form-group input:focus {
            border-color: #007bff;
            box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
        }
        .empty-cart-msg {
            text-align: center;
            padding: 50px;
            color: #666;
        }
        .empty-cart-msg a {
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
        }
        .empty-cart-msg a:hover {
            text-decoration: underline;
        }
    </style>
    <script>
        function showCheckoutForm() {
            document.getElementById('checkoutSection').classList.add('show');
            document.getElementById('proceedBtn').style.display = 'none';
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>🛒 Your Shopping Cart</h2>
        
        <!-- Display Error Message if Present -->
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger" role="alert">
                <strong>Error:</strong> ${param.error}
            </div>
        </c:if>
        
        <%
            // Get the cart from session
            HashMap<Integer, Integer> cart = (HashMap<Integer, Integer>) session.getAttribute("cart");
            ProductDAO productDAO = new ProductDAO();
            double cartTotal = 0.0;
            
            // Store cart and total in request for JSTL access
            request.setAttribute("cart", cart);
            request.setAttribute("productDAO", productDAO);
        %>
        
        <!-- Check if Cart is Empty -->
        <c:choose>
            <c:when test="${empty cart or cart.size() == 0}">
                <div class="empty-cart-msg">
                    <p style="font-size: 18px; margin-bottom: 20px;">Your cart is currently empty.</p>
                    <a href="products.jsp" class="btn btn-primary">Browse Our Products</a>
                </div>
            </c:when>
            
            <c:otherwise>
                <!-- Cart Items Table -->
                <table class="table table-hover cart-table">
                    <thead>
                        <tr>
                            <th>Product Name</th>
                            <th>Unit Price</th>
                            <th>Quantity</th>
                            <th>Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- JSTL forEach to iterate through cart -->
                        <c:set var="cartTotal" value="0.0" />
                        <c:forEach var="entry" items="${cart}">
                            <c:set var="productId" value="${entry.key}" />
                            <c:set var="quantity" value="${entry.value}" />
                            
                            <%
                                int productId = (int) pageContext.getAttribute("productId");
                                ProductDAO dao = (ProductDAO) request.getAttribute("productDAO");
                                Product product = dao.getProduct(productId);
                                pageContext.setAttribute("product", product);
                            %>
                            
                            <c:if test="${not empty product}">
                                <c:set var="subtotal" value="${product.price * quantity}" />
                                <c:set var="cartTotal" value="${cartTotal + subtotal}" />
                                
                                <tr>
                                    <td><strong>${product.name}</strong></td>
                                    <td>
                                        <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$" />
                                    </td>
                                    <td>${quantity}</td>
                                    <td>
                                        <strong>
                                            <fmt:formatNumber value="${subtotal}" type="currency" currencySymbol="$" />
                                        </strong>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </tbody>
                    <tfoot>
                        <tr class="total-row">
                            <td colspan="3" style="text-align: right; padding: 15px;">Grand Total:</td>
                            <td style="padding: 15px;">
                                <fmt:formatNumber value="${cartTotal}" type="currency" currencySymbol="$" />
                            </td>
                        </tr>
                    </tfoot>
                </table>

                <!-- Proceed to Checkout Button -->
                <button id="proceedBtn" class="btn btn-success btn-lg" onclick="showCheckoutForm()">
                    Proceed to Checkout
                </button>

                <!-- Checkout Section (Hidden by Default) -->
                <div id="checkoutSection" class="checkout-section">
                    <h4 style="margin-bottom: 20px;">💳 Payment Details</h4>
                    <p style="color: #555;">Please enter your 16-digit credit card number to finalize your purchase.</p>
                    
                    <!-- Form submits to CheckoutServlet -->
                    <form action="checkout" method="POST" class="form-inline">
                        <div class="form-group mr-3" style="width: 100%; margin-bottom: 15px;">
                            <label for="cardNumber" class="mr-3" style="font-weight: 500;">Credit Card Number:</label><br>
                            <input type="text" id="cardNumber" name="cardNumber" class="form-control" 
                                   required pattern="\d{16}" 
                                   title="Please enter exactly 16 digits" 
                                   placeholder="Enter 16-digit card number"
                                   style="width: 100%; margin-top: 10px;">
                        </div>
                        
                        <button type="submit" class="btn btn-primary btn-lg" style="width: 100%; margin-top: 15px;">
                            Pay <fmt:formatNumber value="${cartTotal}" type="currency" currencySymbol="$" /> and Complete Order
                        </button>
                    </form>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Bootstrap JS (optional) -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
