<%-- 
    Document   : payment-success
    Created on : May 7, 2022, 8:42:14 AM
    Author     : Danh Nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<link rel="stylesheet" href="<c:url value="/resources/css/client/payment.css" />"/>
<div class="container">
    <div class="row">
        <div class="col-md-6 mx-auto mt-5">
            <div class="payment">
                <div class="payment_header">
                    <div class="check"><i class="fa fa-check" aria-hidden="true"></i></div>
                </div>
                <div class="content">
                    <h1>Thanh toán thành công!</h1>
                    <p>Cảm ơn quý khách đã tin tưởng nhà hàng của chúng tôi. Chúng tôi 
                        rất hân hạnh được phục vụ quý khách </p>
                        <sec:authorize access="hasAuthority('USER')">
                        <a href="<c:url value='/user-order?username=${pageContext.request.userPrincipal.name}' />">Go Back</a>
                    </sec:authorize>
                    <sec:authorize access="hasAuthority('STAFF')">
                        <a href="<c:url value='/order' />">Go Back</a>
                    </sec:authorize>
                </div>
            </div>
        </div>
    </div>
</div>
<br><br>