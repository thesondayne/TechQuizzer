<%--
  Created by IntelliJ IDEA.
  User: Ud
  Date: 13-Jun-25
  Time: 9:07 AM
  To change this template use File | Settings | File Templates.
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<!-- Sidebar menu-->
<aside class="app-sidebar">
    <%--    user/setting/subject/question/quiz--%>
    <c:set var="currentPage" value="${param.currentPage}"/>
    <div class="app-sidebar__user">
        <img class="app-sidebar__user-avatar" src="assets/images/avatar/${sessionScope.user.avatar}" alt="User Image">
        <div>
            <p class="app-sidebar__user-name">${sessionScope.user.name}</p>
            <p class="app-sidebar__user-designation">${sessionScope.user.roleName}</p>
        </div>
    </div>
    <ul class="app-menu">
        <c:if test="${sessionScope.user.roleName == 'Admin'}">
            <li><a class="app-menu__item ${currentPage == 'user' ? 'active' : ''}" href="admin"><i
                    class="app-menu__icon bi bi-people-fill"></i><span
                    class="app-menu__label">User List</span></a></li>
            <li><a class="app-menu__item ${currentPage == 'setting' ? 'active' : ''}" href="get-setting-list"><i
                    class="app-menu__icon bi bi-gear-wide-connected"></i><span
                    class="app-menu__label">Setting List</span></a></li>
        </c:if>
        <li><a class="app-menu__item ${currentPage == 'subject' ? 'active' : ''}" href="manage-subject"><i
                class="app-menu__icon bi bi-journal-bookmark"></i><span
                class="app-menu__label">Subject List</span></a></li>
        <li><a class="app-menu__item ${currentPage == 'question' ? 'active' : ''}" href=""><i
                class="app-menu__icon bi bi-question-circle"></i><span
                class="app-menu__label">Question List</span></a></li>
        <c:if test="${sessionScope.user.roleName == 'Expert'}">
            <li><a class="app-menu__item ${currentPage == 'quiz' ? 'active' : ''}" href="quizzeslist"><i
                    class="app-menu__icon bi bi-card-checklist"></i><span
                    class="app-menu__label">Quiz List</span></a></li>
        </c:if>
    </ul>
</aside>
</body>
</html>
