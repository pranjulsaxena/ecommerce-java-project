<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product | Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
    <jsp:include page="admin-header.jsp" />

    <main class="container form-container">
        <h1>Add New Product</h1>
        
        <form action="${pageContext.request.contextPath}/admin/products" method="post" class="admin-form">
            <input type="hidden" name="action" value="insert">
            
            <div class="form-group">
                <label for="name">Product Name:</label>
                <input type="text" id="name" name="name" required class="form-control">
            </div>
            
            <div class="form-group">
                <label for="price">Price ($):</label>
                <input type="number" id="price" name="price" step="0.01" min="0" required class="form-control">
            </div>
            
            <div class="form-group">
                <label for="description">Description:</label>
                <textarea id="description" name="description" rows="5" required class="form-control"></textarea>
            </div>
            
            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">Cancel</a>
                <button type="submit" class="btn btn-primary">Save Product</button>
            </div>
        </form>
    </main>
</body>
</html>
