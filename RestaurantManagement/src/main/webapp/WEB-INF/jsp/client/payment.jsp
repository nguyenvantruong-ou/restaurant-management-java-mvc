<%-- 
    Document   : payment
    Created on : Apr 30, 2022, 8:52:14 PM
    Author     : Danh Nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<br>
<div class="border border-secondary rounded" style="padding: 20px; border-width:10px !important">
    <h1 class="text-center text-info">HOÁ ĐƠN THANH TOÁN</h1>
    <br>
    <c:if test="${orderInfo.size() > 0}">
        <div class="text-center">
            <c:forEach var="o" items="${orderInfo}">
                <h5>Họ & tên: ${o[7]} ${o[6]} </h5>
                <h5>Mã tiệc: ${o[0]} ------ Ngày đặt: <span>${o[1]}</span> </h5>
                <c:set var="ordId" value="${o[0]}"/>
                <h5>Ngày tổ chức: ${o[2]} <small>(${o[3]})</small></h5>
                <h5>Tên sảnh cưới: ${o[4]}</h5>
                <h5>Giá sảnh cưới: <fmt:formatNumber value = "${o[5]}" type = "number"/> VND   x   Hệ số: ${o[8]}</h5>
                <c:set var="totalLobby" value = "${o[5] * o[8]}"/>
                <h5 class="text-right">Tổng tiền sảnh cưới: <fmt:formatNumber value = "${totalLobby}" type = "number"/> VND</h5>
            </c:forEach>
        </div>
    </c:if>

    <c:if test="${menuInfo.size() > 0}">
        <table class="content-table">
            <thead>
                <tr>
                    <th>Tên thực đơn</th>
                    <th>Giá thực đơn</th>
                    <th>Số lượng</th>
                    <th>Thành tiền</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="m" items="${menuInfo}">
                    <tr>
                        <td>${m[0]}</td>
                        <td><fmt:formatNumber value = "${m[1]}" type = "number"/> VND</td>
                        <td>${m[2]}</td>
                        <td><fmt:formatNumber value = "${m[1] * m[2]}" type = "number"/> VND</td>
                    </tr>
                    <c:set var="totalMenu" value = "${m[1] * m[2] + totalMenu}"/>
                </c:forEach>
            </tbody>
        </table>
        <h5 class="text-right">Tổng tiền thực đơn: <fmt:formatNumber value="${totalMenu}" type="number"/> VND</h5>
    </c:if>
    <c:if test="${serInfo.size() > 0}">
        <table class="content-table">
            <thead>
                <tr>
                    <th>Tên dịch vụ</th>
                    <th>Giá dịch vụ</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="s" items="${serInfo}">
                    <tr>
                        <td>${s[0]}</td>
                        <td><fmt:formatNumber value = "${s[1]}" type = "number"/> VND</td>
                    </tr>
                    <c:set var="totalService" value = "${s[1] + totalService}"/>
                </c:forEach>
            </tbody>
        </table>
        <h5 class="text-right">Tổng tiền dịch vụ: <fmt:formatNumber value="${totalService}" type="number"/> VND</h5>
    </c:if>
    <h4 class="text-center text-info">Tổng hoá đơn: <fmt:formatNumber 
            value="${totalService + totalMenu + totalLobby}" type="number"/> VND</h4>
</div>
<br>
<div class="row">
    <div class="col-md-6">
        <form action="<c:url value='/payment-cash/created-bill' />">
            <div>
                <input type="text" name="totalMoney" value="${totalService + totalMenu + totalLobby}" hidden="true"/>
                <input type="text" name="ordId" value="${ordId}" hidden="true"/>
                <input type="text" name="userId" value="10" hidden="true"/>
            </div>
            <div style="padding-left: 60%">
                <input class="btn btn-info" type="submit" value="Thanh toán tiền mặt">
            </div>
        </form>
    </div>
    <div class="col-md-6">
        <form action="<c:url value='/payment-momo/created-bill' />">
            <div>
                <input type="text" name="totalMoney" value="${totalService + totalMenu + totalLobby}" hidden="true"/>
                <input type="text" name="ordId" value="${ordId}" hidden="true"/>
                <input type="text" name="userId" value="10" hidden="true"/>
            </div>
            <div style="padding-left: 20%">
                <input class="btn btn-danger" type="submit" value="Thanh toán Momo">
            </div>
        </form>
    </div>
</div>
</div>
<br>
<br>