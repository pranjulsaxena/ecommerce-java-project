<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="main-footer">
    <div class="container footer-container">
        <div class="footer-info">
            <h3>E-Commerce Store</h3>
            <p>Your one-stop shop for everything you need. Built with Java, Servlets, and MVC.</p>
        </div>
        <div class="footer-links">
            <h4>Quick Links</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/products">Shop</a></li>
                <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
                <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
            </ul>
        </div>
        <div class="footer-admin">
            <h4>Administration</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/admin/products">Admin Dashboard</a></li>
            </ul>
        </div>
    </div>
    <div class="footer-bottom">
        <p>&copy; 2026 E-Commerce Store. All rights reserved.</p>
    </div>
</footer>

<style>
/* Footer CSS */
.main-footer {
    background-color: #1f2937;
    color: #f9fafb;
    padding-top: 3rem;
    margin-top: 4rem;
}

.footer-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 2rem;
    padding-bottom: 2rem;
}

.footer-info h3 {
    font-size: 1.5rem;
    margin-bottom: 1rem;
    color: white;
}

.footer-info p {
    color: #9ca3af;
}

.footer-links h4,
.footer-admin h4 {
    font-size: 1.25rem;
    margin-bottom: 1rem;
    color: white;
}

.footer-links ul,
.footer-admin ul {
    list-style: none;
}

.footer-links li,
.footer-admin li {
    margin-bottom: 0.5rem;
}

.footer-links a,
.footer-admin a {
    text-decoration: none;
    color: #9ca3af;
    transition: color 0.2s;
}

.footer-links a:hover,
.footer-admin a:hover {
    color: white;
}

.footer-bottom {
    text-align: center;
    padding: 1.5rem;
    background-color: #111827;
    color: #9ca3af;
    font-size: 0.875rem;
}
</style>
