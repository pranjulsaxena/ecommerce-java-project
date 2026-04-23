<%@ page import="com.ecommerce.model.User" %>
<%@ page import="com.ecommerce.model.Product" %>
<%@ page import="com.ecommerce.dao.ProductDAO" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    // Bypass: Assuming an admin email or admin role
    if (currentUser == null || !"admin@techstore.com".equals(currentUser.getEmail())) {
        response.sendRedirect("index.jsp");
        return;
    }
    ProductDAO productDAO = new ProductDAO();
    List<Product> products = productDAO.getAllProducts();
%>
<%@ include file="header.jsp" %>
<div class="row mt-5">
    <div class="col-12">
        <h2>Admin Dashboard - Products</h2>
        <table class="table table-striped table-bordered mt-4">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% if (products != null) {
                    for (Product p : products) { %>
                <tr>
                    <td><%= p.getId() %></td>
                    <td><%= p.getName() %></td>
                    <td>$<%= String.format("%.2f", p.getPrice()) %></td>
                    <td><%= p.getStock() %></td>
                    <td>
                        <a href="DeleteProductServlet?id=<%= p.getId() %>" class="btn btn-danger btn-sm">Delete</a>
                    </td>
                </tr>
                <%  }
                   } %>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="footer.jsp" %>
