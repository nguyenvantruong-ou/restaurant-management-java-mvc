<%-- 
    Document   : user-order
    Created on : May 7, 2022, 6:22:57 PM
    Author     : Danh Nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <h1 class="text-center text-danger">Danh Sách Đơn Hàng</h1>
    <c:if test="${orders.size()>0}">
        <table class="content-table">
            <thead>
                <tr>
                    <th>Mã đơn</th>
                    <th>Ngày tạo</th>
                    <th>Ngày đặt</th>
                    <th>Buổi</th>
                    <th>Sảnh cưới</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="o" items="${orders}">
                    <tr>
                        <td>${o.id}</td>
                        <td>${o.ordCreatedDate}</td>
                        <td>${o.ordBookingDate}</td>
                        <td>${o.ordBookingLesson}</td>
                        <td>${o.lob.lobName}</td>
                        <c:if test="${o.ordIsPayment == false}">
                            <td>
                                <a href="<c:url value='/payment?id=${o.id}' />">
                                    <input style="margin-right: 30px; margin-left: 10px" type="button" class="btn btn-success" value="Thanh toán" />
                                </a>
                                <a href="<c:url value='/user-order/delete?ordId=${o.id}&username=${pageContext.request.userPrincipal.name}' />">
                                    <input type="button" class="btn btn-danger" value="Huỷ" />
                                </a>
                            </td>
                        </c:if>
                        <c:if test="${o.ordIsPayment == true}">
                            <td class="text-center text-info"><h5>Đã thanh toán</h5></td>
                        </c:if>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
    <c:if test="${orders.size() <= 0}">
        <h3 style="padding: 15%" class="text-center text-info">Bạn chưa có bất kì đơn hàng nào!!!</h3>
    </c:if>