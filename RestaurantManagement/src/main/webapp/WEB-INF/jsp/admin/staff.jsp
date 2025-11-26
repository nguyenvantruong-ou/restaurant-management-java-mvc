<%--
  Created by IntelliJ IDEA.
  User: Wall D
  Date: 4/22/2022
  Time: 8:18 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<section class="home">
    <h1 class="text-center">QUẢN LÍ NHÂN VIÊN</h1>
    <div class="">
        <form action="">
            <div class="box">
                <i class="fa fa-search" aria-hidden="true"></i>
                <input class="form-control" type="text" name="kw" placeholder="Nhập tên cần tìm...."/>
            </div>
        </form>
        <div>
            <a href="<c:url value='/admin/staff/add' />"><input class="button button-edit" type="button" value="Thêm mới nhân viên"/></a>
        </div>
        <table class="content-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Họ và tên</th>
                    <th>Giới tính</th>
                    <th>Số CCCD/CMND</th>
                    <th>Số điện thoại</th>
                    <th>Ngày sinh</th>
                    <th>Loại người dùng</th>
                    <th>Ảnh đại diện</th>
                    <th></th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="u" items="${users}">
                    <c:set value="black" var="color"/>
                    <c:if test="${u.userIsActive == false}">
                        <c:set value="red" var="color"/>
                    </c:if>
                    <tr>
                        <td style="color: ${color}">${u.id}</td>
                        <td style="color: ${color}">${u.userLastName} ${u.userFirstName}</td>
                        <c:if test="${u.userSex == true}">
                            <td style="color: ${color}">Nam</td>
                        </c:if>
                        <c:if test="${u.userSex == false}">
                            <td style="color: ${color}">Nữ</td>
                        </c:if>
                        <td style="color: ${color}">${u.userIdCard}</td>
                        <td style="color: ${color}">${u.userPhoneNumber}</td>
                        <td style="color: ${color}">${u.userDateOfBirth}</td>
                        <td style="color: ${color}">${u.userRole}</td>
                        <td>
                            <c:if test="${u.userImage == null && u.userSex == true}">
                                <img class="rounded-circle" width="50" height="50" alt="IMG" src="https://res.cloudinary.com/dqifjhxxg/image/upload/v1650672290/restaurant%20management/user/man_psirpi.jpg"/>
                            </c:if>
                            <c:if test="${u.userImage == null && u.userSex == false}">
                                <img class="rounded-circle" width="50" height="50" alt ="IMG" src="https://res.cloudinary.com/dqifjhxxg/image/upload/v1650672293/restaurant%20management/user/woman_cqjaa5.jpg" />
                            </c:if>
                            <c:if test="${u.userImage != null}">
                                <img class="rounded-circle" width="50" height="50" alt="IMG" src="${u.userImage}">
                            </c:if>
                        </td>
                        <td><a href="<c:url value="/admin/staff/edit?id=${u.id}"/>"><input class="button button-edit" type="button" value="Sửa"/></a></td>
                        <td><a href="<c:url value="/admin/staff/delete?id=${u.id}"/>"><input class="button button-delete" onclick="confirmForm(event)" type="button" value="Xoá"/></a></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</section>
<script>
    function confirmForm(e) {
        if (!confirm("Xác nhận xoá?"))
            e.preventDefault();
    }
</script>