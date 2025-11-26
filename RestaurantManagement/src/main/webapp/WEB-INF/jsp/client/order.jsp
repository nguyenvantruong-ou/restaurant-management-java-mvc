<%-- 
    Document   : payment
    Created on : Apr 30, 2022, 4:25:55 PM
    Author     : Danh Nguyen
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<section class="home">
    <div class="container my-4">
        <div class="d-flex justify-content-center">
            <h2 class="text-center text-info">DANH SÁCH ĐƠN CHƯA THANH TOÁN</h2>
        </div>
        <div>
            <form action="" class="form-inline">
                <input style="margin-left: 100px" type="text" id="text" name="kw" class="form-control w-75" placeholder="Nhập số điện thoại của khách hàng....">
                <input style="margin-left: 5px" type="submit" class="btn btn-info" value="Tìm kiếm">
            </form>
        </div>
    </div>
    <div style="display: flex">
        <ul class="pagination" style="margin:0px auto">
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
    <div class ="table">
        <table class="content-table">
            <thead>
                <tr>
                    <th>Mã</th>
                    <th>Họ và tên</th>
                    <th>Giới tính</th>
                    <th>Số CCCD/CMND</th>
                    <th>Số điện thoại</th>
                    <th>Ngày đặt</th>
                    <th>Ngày tổ chức</th>
                    <th>Buổi</th>
                    <th></th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="o" items="${orders}">
                    <tr>
                        <td>${o[0]}</td>
                        <td>${o[1]} ${o[2]}</td>
                        <c:if test="${o[3] == true}">
                            <td>Nam</td>
                        </c:if>
                        <c:if test="${o[3] == false}">
                            <td>Nữ</td>
                        </c:if>
                        <td>${o[4]}</td>
                        <td>${o[5]}</td>
                        <td>${o[6]}</td>
                        <td>${o[7]}</td>
                        <td>${o[8]}</td>
                        <td><a href="<c:url value='/payment?id=${o[0]}' />"><input type="submit" id="submitbutton" value="Thanh toán" class="btn btn-success"></a></td>
                        <td><a href="<c:url value='/order/delete?ordId=${o[0]}' />"><input type="submit" id="submitbutton" value="Xoá" class="btn btn-danger"></a></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</section>
<script>
    //ghi dè bass
    window.onscroll = function () {
        var winScroll = document.body.scrollTop || document.documentElement.scrollTop;
        var height = document.documentElement.clientHeight - document.body.clientHeight;

        var scrolled = (winScroll / height) * 100;
        document.getElementById("myBar").style.width = scrolled + "%";
        if (document.body.scrollTop > 100 || document.documentElement.scrollTop > 100) {
            document.getElementById("header-nav").style.position = "fixed"
            document.getElementById("header-nav").style.zIndex = "10000"
            document.getElementById("header-nav").style.width = "100%"
            document.getElementById("header-nav").style.marginTop = "-30px"
        } else {
            document.getElementById("header-nav").style.position = "initial";
            document.getElementById("header-nav").style.marginTop = "0px"
        }
    }
</script>
