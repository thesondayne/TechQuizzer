<%--
  Created by IntelliJ IDEA.
  User: LAM
  Date: 29/05/2025
  Time: 6:01 CH
  To change this template use File | Settings | File Templates.
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <jsp:include page="./common/headload.jsp"/>
    <title>Edit User</title>
</head>
<body class="app sidebar-mini">
<!-- Navbar-->
<jsp:include page="./layout/manage/header.jsp"/>

<!-- Sidebar menu-->
<jsp:include page="./layout/manage/sidebar.jsp">
    <jsp:param name="currentPage" value="user"/>
</jsp:include>
<%--User profile--%>
<jsp:include page="./user_profile.jsp"/>
<main class="app-content">
    <div class="app-title">
        <div>
            <h1><i class="bi bi-pencil-square"></i> Edit User</h1>
        </div>
        <ul class="app-breadcrumb breadcrumb">
            <li class="breadcrumb-item"><a href="admin">User List</a></li>
            <li class="breadcrumb-item active">Edit User</li>
        </ul>
    </div>

    <div class="row">
        <div class="col-md-8 offset-md-2">
            <div class="tile">
                <div class="tile-body">
                    <form action="admin" method="post">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="id" value="${user.id}">

                        <div class="mb-3 text-center">
                            <img src="assets/images/avatar/${user.avatar != null ? user.avatar : 'default.webp'}"
                                 alt="User Avatar"
                                 style="width: 150px; height: 180px; object-fit: cover; border: 2px solid #4d5154; border-radius: 8px;">
                        </div>

                        <div class="mb-3">
                            <label>Email</label>
                            <p class="form-control-plaintext">${user.email}</p>
                            <input type="hidden" name="email" value="${user.email}">
                        </div>

                        <div class="mb-3">
                            <label>Name</label>
                            <input type="text" class="form-control" name="name" value="${user.name}" required>
                        </div>

                        <div class="mb-3">
                            <label>Role</label>
                            <select class="form-select" name="roleId">
                                <option value="1" ${user.roleId == 1 ? 'selected' : ''}>Admin</option>
                                <option value="2" ${user.roleId == 2 ? 'selected' : ''}>Expert</option>
                                <option value="3" ${user.roleId == 3 ? 'selected' : ''}>Customer</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label>Gender</label><br>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="gender" value="true" ${user.gender ? 'checked' : ''}>
                                <label class="form-check-label">Male</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="gender" value="false" ${!user.gender ? 'checked' : ''}>
                                <label class="form-check-label">Female</label>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label>Mobile</label>
                            <input type="text" class="form-control" name="mobile" value="${user.mobile}">
                        </div>

                        <div class="mb-3">
                            <label>Address</label>
                            <textarea class="form-control" name="address">${user.address}</textarea>
                        </div>

                        <div class="mb-3">
                            <label>Balance</label>
                            <input type="number" class="form-control" name="balance" value="${user.balance}" step="0.01">
                        </div>

                        <div class="mb-3">
                            <label>Status</label>
                            <select class="form-select" name="status">
                                <option value="true" ${user.status ? 'selected' : ''}>Active</option>
                                <option value="false" ${!user.status ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>

                        <div class="mt-3">
                            <a href="admin" class="btn btn-secondary">Cancel</a>
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<%@include file="common/jsload.jsp" %>
</body>
</html>

