<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<header class="admin-header">
    <div class="container admin-header-container">
        <div class="logo">
            <a href="${pageContext.request.contextPath}/admin/products">
                <h2>Admin<span>Panel</span></h2>
            </a>
        </div>
        <nav class="navbar">
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/admin/products">Manage Products</a></li>
                <!-- Future Dev Modules (Orders, Users, etc.) can be linked here -->
                <li><a href="${pageContext.request.contextPath}/products">View Store</a></li>
                <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
        </nav>
    </div>
</header>

<style>
/* Admin Header CSS */
.admin-header {
    background-color: #111827;
    color: white;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    position: sticky;
    top: 0;
    z-index: 1000;
}

.admin-header-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-top: 1rem;
    padding-bottom: 1rem;
}

.admin-header .logo a {
    text-decoration: none;
    color: white;
}

.admin-header .logo h2 {
    font-size: 1.5rem;
    font-weight: 700;
}

.admin-header .logo span {
    color: #ef4444; /* Red color for Admin */
}

.admin-header .nav-links {
    list-style: none;
    display: flex;
    gap: 1.5rem;
}

.admin-header .nav-links a {
    text-decoration: none;
    color: #d1d5db;
    font-weight: 500;
    transition: color 0.2s;
}

.admin-header .nav-links a:hover {
    color: white;
}
</style>
