<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<header class="main-header">
    <div class="container header-container">
        <div class="logo">
            <a href="${pageContext.request.contextPath}/products">
                <h2>E-Commerce<span>Store</span></h2>
            </a>
        </div>
        <nav class="navbar">
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/products">Products</a></li>
                <li><a href="${pageContext.request.contextPath}/cart">Cart</a></li>
                <!-- Assuming Dev 4 handles Authentication / Session -->
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li><a href="${pageContext.request.contextPath}/profile">My Account</a></li>
                        <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
                        <li><a href="${pageContext.request.contextPath}/register">Register</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </nav>
    </div>
</header>

<style>
/* Header CSS - adding inline for simplicity or can be merged to styles.css */
.main-header {
    background-color: var(--card-bg);
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    position: sticky;
    top: 0;
    z-index: 1000;
}

.header-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-top: 1rem;
    padding-bottom: 1rem;
}

.logo a {
    text-decoration: none;
    color: var(--text-color);
}

.logo h2 {
    font-size: 1.5rem;
    font-weight: 700;
}

.logo span {
    color: var(--primary-color);
}

.nav-links {
    list-style: none;
    display: flex;
    gap: 1.5rem;
}

.nav-links a {
    text-decoration: none;
    color: var(--secondary-color);
    font-weight: 500;
    transition: color 0.2s;
}

.nav-links a:hover {
    color: var(--primary-color);
}
</style>
