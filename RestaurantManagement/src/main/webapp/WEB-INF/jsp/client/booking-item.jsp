<%-- 
    Document   : booking-menu
    Created on : Apr 30, 2022, 8:22:29 PM
    Author     : Danh Nguyen
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="border border-secondary rounded" style="padding: 20px; border-width:10px !important">
    <h2 class="text-center text-info">ĐẶT MÓN ĂN VÀ DICH VỤ</h2>
    <c:if test="${order!=null}">
        <div class="text-center">
            <h3>Thông tin đặt hàng</h3>
            <h5>Họ & tên khách hàng: ${order.user.userLastName} ${order.user.userFirstName}</h5>
            <h5>Ngày đặt: ${order.ordCreatedDate}</h5>
            <h5>Ngày tổ chức tiệc: ${order.ordBookingDate} (${order.ordBookingLesson})</h5>
            <h5>Sảnh cưới: ${order.lob.lobName} ---  Sức chứa: ${order.lob.lobTotalTable} bàn</h5>
        </div>
    </c:if>
    <br>
    <div class="row">
        <div class="col-md-5">
            <br>
            <br>
            <br>
            <c:if test="${!error.isEmpty()}">
                <div class="alert alert-danger">Vui lòng đặt số lượng bàn từ 
                    ${order.lob.lobTotalTable*60/100} đến ${order.lob.lobTotalTable} bàn
                </div>
            </c:if>
            <form class="form-group" action="<c:url value='/booking-menu' />">
                <div>
                    <input type="text" value="${order.id}" hidden="true" name="ordId"/>
                    <div>
                        <label>Thực đơn</label>
                        <select name="menuId"">
                            <c:forEach var="m" items="${menu}">
                                <option value="${m.id}">${m.menuName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label>Số lượng bàn</label>
                        <input type="number" min="1" value="1" name="amount"/>
                    </div>
                </div>
                <input type="submit" value="Chọn menu" class="btn btn-danger" />
            </form>
        </div>
        <div class="col-md-7">
            <c:if test="${orderMenu!=null}">
                <h4 class="text-center">Danh sách thực đơn đã chọn</h4>
                <table class="content-table">
                    <thead>
                        <tr>
                            <td>Tên thực đơn</td>
                            <td>Số lượng</td>
                            <td>Giá</td>
                            <td></td>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="om" items="${orderMenu}">
                            <tr>
                                <td>${om.menu.menuName}</td>
                                <td>${om.amountTable}</td>
                                <td>${om.menu.menuPrice}</td>
                                <td>
                                    <a href="<c:url value='/booking-menu-delete?ordId=${order.id}&menuId=${om.menu.id}' />">
                                        <input type="button" value="Xoá" class="btn btn-danger" />
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            <c:if test="${orderMenu.size()==0}"><div class="text-center"><i>Chưa có menu nào được chọn!!!</i></div></c:if>
            </div>
        </div>
        <div class="row">
            <div class="col-md-5">
                <br>
                <br>
                <br>
                <form class="form-group" action="<c:url value='/booking-service' />">
                    <div>
                        <input type="text" value="${order.id}" hidden="true" name="ordId"/>
                    <label>Dich vụ</label>
                    <select name="serId">
                        <c:forEach var="s" items="${services}">
                            <option value="${s.id}">${s.serName}</option>
                        </c:forEach>
                    </select>
                </div>
                <input type="submit" value="Chọn dịch vụ" class="btn btn-danger" />
            </form>
        </div>
        <div class="col-md-7">
            <c:if test="${orderService!=null}">
                <h4 class="text-center">Danh sách dịch vụ đã chọn</h4>
                <table class="content-table">
                    <thead>
                        <tr>
                            <td>Tên dịch vụ</td>
                            <td>Giá</td>
                            <td></td>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="os" items="${orderService}">
                            <tr>
                                <td>${os.ser.serName}</td>
                                <td>${os.ser.serPrice}</td>
                                <td>
                                    <a href="<c:url value='/booking-service-delete?ordId=${order.id}&serId=${os.ser.id}' />">
                                        <input type="button" value="Xoá" class="btn btn-danger" />
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            <c:if test="${orderService.size()==0}"><div class="text-center"><i>Chưa có dịch nào được chọn!!!</i></div></c:if>
            </div>
        </div>
    </div>
    <br><br>
    <div class="text-center">
        <a href="<c:url value='/booking-complete?ordId=${order.id}' />" >
        <input style="width: 250px; " type="button" value="Hoàn tất" class="btn btn-success" />
    </a>
</div>
<br><br>