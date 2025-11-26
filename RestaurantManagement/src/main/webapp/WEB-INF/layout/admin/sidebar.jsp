<%-- 
    Document   : sidebar
    Created on : Apr 27, 2022, 6:57:30 PM
    Author     : Danh Nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script src="<c:url value="/resources/js/client/contification.js" />" ></script>
<!-- Sidebar  -->
<nav id="sidebar" >
    <div class="sidebar-header">
        <h3>Nhà Hàng</h3>
        <h3>Thành Văn</h3>
        <strong>TV</strong>
    </div>
    <ul class="list-unstyled components">
        <li class="active">
            <a href="<c:url value='/admin' />">
                <i class="fas fa-home"></i>
                <span class="item">Trang chủ</span>
            </a>
        </li>
        <li>
            <a href="<c:url value='/admin/staff' />">
                <i class='bx bx-male-female icon'></i>
                <span class="item">Quản lý nhân viên</span>
            </a>
            <a href="<c:url value='/admin/lobby' />">
                <i class='bx bxs-institution'></i>
                <span class="item">Quản lý sảnh cưới</span>
            </a>
            <a href="<c:url value='/admin/service' />">
                <i class='bx bx-receipt'></i>
                <span class="item">Quản lý dịch vụ</span>
            </a>
            <a href="#homeSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                <i class='bx bx-bar-chart'></i>
                <span class="item">Thống kê doanh thu</span>
            </a>
            <ul class="collapse list-unstyled" id="homeSubmenu">
                <li>
                    <a href="<c:url value='/admin/bill-day-stats' />">Ngày</a>
                </li>
                <li>
                    <a href="<c:url value='/admin/bill-month-stats' />">Tháng</a>
                </li>
                <li>
                    <a href="<c:url value='/admin/bill-quarter-stats' />">Quý</a>
                </li>
                <li>
                    <a href="<c:url value='/admin/bill-year-stats' />">Năm</a>
                </li>
            </ul>
            <a href="#pageSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                <i class='bx bx-pie-chart-alt-2'></i>
                <span class="item">Thống kê mật độ</span>
            </a>
            <ul class="collapse list-unstyled" id="pageSubmenu">
                <li>
                    <a href="<c:url value='/admin/order-month-stats' />">Tháng</a>
                </li>
                <li>
                    <a href="<c:url value='/admin/order-quarter-stats' />">Quý</a>
                </li>
                <li>
                    <a href="<c:url value='/admin/order-year-stats' />">Năm</a>
                </li>
            </ul>
        </li>
        <li>
            <a href="<c:url value='/admin/profile' />">
                <i class='bx bx-user icon'></i>
                <span class="item">Thông tin quản trị viên</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="<c:url value='/admin/feedback' />">
                <i class='bx bx-bell'></i>
               <span class="item">Thông báo</span>
                <sup id="count-conti" style="background:red; padding: 2px 4px; border-radius: 15px">0</sup>
            </a>
        </li>
        <li>
            <a href="<c:url value='/logout' />">
                <i class='bx bx-log-out icon' ></i>
                <span class="item">Đăng xuất</span>
            </a>
        </li>
    </ul>
</nav>
<!-- jQuery CDN - Slim version (=without AJAX) -->
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<!-- Popper.JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js" integrity="sha384-cs/chFZiN24E4KMATLdqdvsezGxaGsi4hLGOzlXwp5UZB1LY//20VyM2taTB4QvJ" crossorigin="anonymous"></script>
<!-- Bootstrap JS -->
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js" integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm" crossorigin="anonymous"></script>

<script type="text/javascript">
    $(document).ready(function () {
        $('#sidebarCollapse').on('click', function () {
            $('#sidebar').toggleClass('active');
        });
    });
</script>