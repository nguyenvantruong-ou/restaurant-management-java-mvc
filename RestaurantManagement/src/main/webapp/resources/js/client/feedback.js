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

window.onload = function () {
    document.getElementById("captcha-text").innerHTML = makeid()
    document.getElementById("text-captcha").value = ""
}

var code;
var flag = 0;
function makeid() {
    var text = "";
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

    for (var i = 0; i < 6; i++)
        text += possible.charAt(Math.floor(Math.random() * possible.length))

    code = text
    return text
}

function checkCaptcha(e, event) {
    document.getElementById("text-captcha").style.border = "1px solid black"
    document.getElementById("err-captcha").style.display = "none"
    if (code == e.value) {
        flag = 1;
        document.getElementById("pass-captcha").style.display = "inline"
        document.getElementById("text-captcha").disabled = true;
    } else if (event.keyCode == 13) {
        document.getElementById("text-captcha").style.border = "1px solid red"
        document.getElementById("err-captcha").style.display = "inline"
    }
}

function sendFeedback() {
    let user_name = document.getElementById("username-header").innerHTML
    if (user_name == null) {
        Swal.fire({
            title: 'Bạn chưa đăng nhập',
            text: "Bạn có muốn đăng nhập ngay bây giờ không?",
            icon: 'warning',
            showCancelButton: true,
            cancelButtonText: "Không",
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Đăng nhập'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location = "/sign-in";
            }

        })
    } else if (document.getElementById("content").value.trim() == null ||
            document.getElementById("content").value.trim() == "") {
        Swal.fire({
            icon: 'error',
            title: 'Nội dung rỗng !',
            text: 'Vui lòng nhập nội dung'
        })
    } else if (flag == 0) {
        document.getElementById("text-captcha").style.border = "1px solid red"
        document.getElementById("err-captcha").style.display = "inline"
    } else {
        saveFeedback(user_name)
    }
}

function saveFeedback(user_name) {
    fetch("/api/feedback", {
        method: 'post',
        body: JSON.stringify({
            "content": document.getElementById("content").value.trim(),
            "user_name": user_name
        }),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(function (res) {
        console.info(res)

        return res.json();
    }).then(function (data) {
        if (data == true) {
            Swal.fire({
                title: 'Chúng tôi đã nhận',
                text: 'Cảm ơn bạn đang phản hồi',
                icon: 'success',
                showCancelButton: false,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Trờ lại'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location = "/";
                }

            })
            document.getElementById("content").disabled = true
            document.getElementById("btn-send").disabled = true
        }
        else {
            Swal.fire({
                title: 'Hệ thống đang bảo trì !',
                text: 'Vui lòng quay lại sau',
                icon: 'warning',
                showCancelButton: false,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Trờ lại'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location = "/";
                }

            })
        }
    })
}