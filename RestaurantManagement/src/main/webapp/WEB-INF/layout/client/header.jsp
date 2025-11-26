<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<header id="header-nav">
    <nav class="navbar navbar-expand-sm bg-black navbar-dark">
        <!-- Brand -->
        <a class="navbar-brand" style="margin-left: 15px" href="<c:url value='/' />">
            <img width="50px" height="50px" src="<c:url value="/resources/images/toast.png" />" alt="TV"/>
        </a>
        <!-- Links -->
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" href="<c:url value='/#lobbyTV' />">Sảnh</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="menu">Danh sách món</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="service">Dịch vụ</a>
            </li>
        </ul>
        <ul  class="navbar-nav" style="margin-left: auto; margin-right: 15px">
            <c:if test="${pageContext.request.userPrincipal.name != null}">
                <sec:authorize access="hasAuthority('USER')">
                    <li class="nav-item">
                        <a class="nav-link" href="feedback">Liên hệ</a>
                    </li>
                     <li class="nav-item">
                        <a class="nav-link" 
                           href="<c:url value='/user-order?username=${pageContext.request.userPrincipal.name}' />">
                            Đơn hàng của tôi
                        </a>
                    </li>
                </sec:authorize>
            </c:if>
            <c:if test="${pageContext.request.userPrincipal.name == null}">
                <li class="nav-item">
                    <a class="nav-link" href="feedback">Liên hệ</a>
                </li>
            </c:if>
            <div style="display: flex;margin-top: 10;">
                <c:choose>
                    <c:when test="${pageContext.request.userPrincipal.name == null}">
                        <li class="nav-item">
                            <a class="nav-link" href="sign-up">Đăng kí</a>
                        </li>
                        <li class="nav-item" >
                            <a class="nav-link" href="sign-in">Đăng nhập</a>
                        </li>
                    </c:when>
                    <c:when test="${pageContext.request.userPrincipal.name != null}">
                        <sec:authorize access="hasAuthority('STAFF')">
                            <li class="nav-item">
                                <a class="nav-link" href="order">Danh sách hoá đơn</a>
                            </li>
                        </sec:authorize>
                        <sec:authorize access="hasAuthority('USER')">
                            <li class="nav-item">
                                <a class="nav-link" href="booking">Đặt tiệc</a>
                            </li>
                        </sec:authorize>
                        <li class="nav-item" >
                            <a id="username-header" class="nav-link" style="color: #c47135!important" href="#">${pageContext.request.userPrincipal.name}</a>
                        </li>
                        <li class="nav-item" >
                            <a class="nav-link" href="logout">Đăng xuất</a>
                        </li>
                    </c:when>
                </c:choose>
            </div>
        </ul>

    </nav>      
    <!--  Scroll -->
    <div class="progress-container">
        <div class="progress-bar" id="myBar" style="background: #c47135 ;"></div>
    </div>  
</header>
