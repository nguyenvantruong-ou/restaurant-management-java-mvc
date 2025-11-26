<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib  prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<h1 class="text-center" style="margin: 30px 0 30px 0; color: #8d7a4a">XÁC NHẬN</h1>

<c:url value="/confirm-sign-up-again" var="again" />
<c:url value="/confirm-sign-up" var="action" />
<c:if test="${err != null}">
    <div class="alert alert-danger">${err}</div>
</c:if>
    <hr>
<p>Chúng tôi đã gửi mật mã cho ${vocative} qua email: ${email} </p>
<p>Vui lòng kiểm tra email. Xin trân trọng cảm ơn!</p>
<form:form method="post" action="${action}"  modelAttribute="code" >
    <div class="row">
        <div class="form-group col-lg-3">
            <form:input type="text" cssStyle="width: 100%;text-align: center;" path="codeNumber" />
        </div>
        <div class="col-lg-2">
            <a href="" onclick="sendAgain()">Gửi lại</a>
        </div>
    </div>
        <div class="form-group"">
            <form:button class="btn btn-success" >Xác nhận</form:button>
        </div>
</form:form>

<script>
    function sendAgain() {
    fetch(`/api/sign-in-again`).then(res => res.json()).then(data => {
    })
    }
</script>