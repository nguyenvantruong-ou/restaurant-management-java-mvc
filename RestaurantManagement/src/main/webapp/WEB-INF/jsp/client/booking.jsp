<%-- 
    Document   : booking
    Created on : Apr 30, 2022, 7:00:46 PM
    Author     : Danh Nguyen
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:if test="${errMsg!=null}">
    <h4 class="text-center alert alert-danger">${errMsg}</h4>
</c:if>
<br>
<h1 class="text-center text-danger">ĐẶT SẢNH CƯỚI</h1>
<br>
<div class="text-center">
    <form class="form-group" action="<c:url value='/booking' />">
        <div style="margin-bottom: 10px">
            <label>Sảnh cưới </label>
            <select name="lobId" style="width: 312px; height: 30px">
                <c:forEach var="l" items="${lobby}">
                    <option value="${l.id}">${l.lobName}</option>
                </c:forEach>
            </select>
        </div>
        <div>
            <label>Ngày tổ chức </label>
            <input style="margin-right: 22px" name="bookingDate" type="date"/>
            <label>Buổi </label>
            <select name="lesson" style="width: 100px; height: 30px">
                <option value="sáng"> sáng </option>
                <option value="trưa"> trưa </option>
                <option value="tối"> tối </option>
            </select>
        </div>
        <input type="text" name="username" value="${pageContext.request.userPrincipal.name}" class="btn btn-danger" hidden="true"/>
        <input style="margin-top: 10px"type="submit" value="Chọn sảnh" class="btn btn-info" />
    </form>
</div>
<div style="display: flex">
    <ul class="pagination" style="margin: 10px auto">
        <li class="page-item" style="cursor: pointer;"><a class="page-link" onclick="previous()" >Previous</a></li>
            <%--   Phan trang     --%>
            <c:forEach begin="1" end="${Math.ceil(numberPage/5)}" var="i">
                <c:choose>
                    <c:when test="${kw==''}">
                    <li class="page-item"><a id="page${i}" class="page-link" href="<c:url value="" />?page=${i} ">${i}</a></li>
                    </c:when>
                    <c:otherwise>
                    <li class="page-item"><a id="page${i}" class="page-link" href="?kw=${kw}&page=${i}">${i}</a></li>
                    </c:otherwise>
                </c:choose>
                <%--                <li class="page-item"><a class="page-link" href="<c:url value="" />?page=${i} ">${i}</a></li>--%>
            </c:forEach>
        <li class="page-item" style="cursor: pointer;"><a class="page-link" onclick="next(${Math.ceil(numberPage/5)})">Next</a></li>
    </ul>
</div>
<table class="content-table">
    <thead>
        <tr>
            <td>Mã sảnh cưới</td>
            <td>Tên sảnh cưới</td>
            <td>Số bàn</td>
            <td>Địa chỉ</td>
            <td>Giá</td>
            <td>Ảnh</td>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="l" items="${lobbies}">
            <tr>
                <td>${l.id}</td>
                <td>${l.lobName}</td>
                <td>${l.lobTotalTable}</td>
                <td>${l.lobAddress}</td>
                <td>${l.lobPrice}</td>
                <c:if test="${l.lobImage!=null}">
                    <td><img class="rounded-circle" width="100" height="100" src="${l.lobImage}" alt="imgae"/></td>
                    </c:if>
                    <c:if test="${l.lobImage==null}">
                    <td><img class="rounded-circle" width="50" height="50" src="<c:url value="/resources/images/toast.png" />" alt="imgae"/></td>
                    </c:if>
            </tr>
        </c:forEach>
    </tbody>
</table>