var numberStar = 0;
var totalCmt = 0;
var totalStar = 0;
//kiem tra kiem tra username
$("#username").ready(function () {
    var x = location.href
    var lob_id = x.slice(x.indexOf('?id=') + 4)
    let username = document.getElementById("username").innerHTML;
    if (username != null && username != "") {
        fetch("/api/check-username-in-bill", {
            method: 'post',
            body: JSON.stringify({
                "username": username,
                "lob_id": lob_id
            }),
            headers: {
                "Content-Type": "application/json"
            }
        }).then(function (res) {
            console.info(res);
            return res.json();
        }).then(function (data) {
            alert(data)
            if (data == true)   // neu user cos bill
                showComment();
        });
    }
    getListCmtByLobbyId();
})

function showComment() {
    let cmt = `<textarea id="content" class="form-control" rows="7" width="100%" placeholder="Nội dung ..."></textarea> 
                <div  style="color: #cacaca; font-size: 25px; padding: 20px 0">
                    <i id="star1" class="fa fa-star" aria-hidden="true" onclick="setStar(1)"></i>
                    <i id="star2" class="fa fa-star" aria-hidden="true" onclick="setStar(2)"></i>
                    <i id="star3" class="fa fa-star" aria-hidden="true" onclick="setStar(3)"></i>
                    <i id="star4" class="fa fa-star" aria-hidden="true" onclick="setStar(4)"></i>
                    <i id="star5" class="fa fa-star" aria-hidden="true" onclick="setStar(5)"></i>
                    <span id="star-text" style="font-size: 22px;font-family: initial;margin-left: 25px;"></span>
                </div>
                <button class="btn btn-success" style="margin-top: 10px;" type="button" onclick="checkComment()">Gửi đánh giá của bạn</button>`
    document.getElementById("comment").insertAdjacentHTML('beforeend', cmt)
}

function checkComment() {
    let content = document.getElementById("content").value
    if (content.trim() == "" || content.trim() == null) {
        Swal.fire({
            title: 'Nội dung không được để trống !',
            text: 'Vui lòng kiểm tra lại',
            icon: 'warning',
            showCancelButton: false,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Trờ lại'
        })
    } else if (numberStar == 0) {
        Swal.fire({
            title: 'Vui lòng đánh giá sao!',
            text: 'Vui lòng kiểm tra lại',
            icon: 'warning',
            showCancelButton: false,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Trờ lại'
        })
    } else {
//        save cmt
        saveComment()
    }
}

function saveComment() {
    var x = location.href
    var lob_id = x.slice(x.indexOf('?id=') + 4)
    let username = document.getElementById("username").innerHTML;
    let content = document.getElementById("content").value;
    fetch("/api/save-comment", {
        method: 'post',
        body: JSON.stringify({
            "username": username,
            "lob_id": lob_id,
            "content": content,
            "stars": numberStar
        }),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(function (res) {
        console.info(res);
        return res.json();
    }).then(function (data) {
        if (data == true) {
            Swal.fire({
                title: 'Đánh giá thành công!',
                text: 'Cảm ơn quý khách',
                icon: 'success',
                showCancelButton: false,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Trờ lại'
            })
            $('div').remove('#comment');
            $('div').remove('#flag-cmt');
            xCmt = 0;
            getListCmtByLobbyId();
        } else {
            Swal.fire({
                title: 'Hệ thống đang bảo trì!',
                text: 'Vui lòng quay lại sau',
                icon: 'warning',
                showCancelButton: false,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Trờ lại'
            })
        }
    });
}

function setStar(index) {
    numberStar = index;
    for (var i = 1; i <= 5; i++) {
        document.getElementById("star" + i).style.color = "#cacaca"
    }
    for (var i = 1; i <= index; i++) {
        document.getElementById("star" + i).style.color = "#fe8b23"
    }
    setStarText(index);
}

function setStarText(index) {
    switch (index) {
        case 1 :
        {
            document.getElementById("star-text").style.color = "red"
            document.getElementById("star-text").innerHTML = "Rất tệ";
            break;
        }
        case 2 :
        {
            document.getElementById("star-text").style.color = "#d73e3e"
            document.getElementById("star-text").innerHTML = "Tệ";
            break;
        }
        case 3 :
        {
            document.getElementById("star-text").style.color = "#c47135"
            document.getElementById("star-text").innerHTML = "Bình thường";
            break;
        }
        case 4 :
        {
            document.getElementById("star-text").style.color = "#28a745"
            document.getElementById("star-text").innerHTML = "Hài lòng";
            break;
        }
        case 5 :
        {
            document.getElementById("star-text").style.color = "#28a745"
            document.getElementById("star-text").innerHTML = "Rất hài lòng";
            break;
        }
    }
}

function countCommentByLobId(lob_id) {
    fetch("/api/count-comment-by-lob-id", {
        method: 'post',
        body: JSON.stringify({
            "lob_id": lob_id
        }),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(function (res) {
        console.info(res);
        return res.json();
    }).then(function (data) {
        totalCmt = data;
    });
}

function totalStarsByLobId(lob_id) {
    fetch("/api/total-stars-by-lob-id", {
        method: 'post',
        body: JSON.stringify({
            "lob_id": lob_id
        }),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(function (res) {
        console.info(res);
        return res.json();
    }).then(function (data) {
        totalStar = data;
    });
}

var xCmt = 0;
function getListCmtByLobbyId() {
    xCmt += 1;
    var x = location.href
    var lob_id = x.slice(x.indexOf('?id=') + 4)
    countCommentByLobId(lob_id);
    totalStarsByLobId(lob_id);
    fetch("/api/get-list-comment-by-lob-id", {
        method: 'post',
        body: JSON.stringify({
            "lob_id": lob_id,
            "x": xCmt
        }),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(function (res) {
        console.info(res);
        return res.json();
    }).then(function (data) {
        x += 1;
        showListComment(data)
    });
}

function showAvgStars() {
    $('i').remove('#star-i');
    var nAvg;
    var n;
    if (totalCmt != 0) {
        n = Math.floor(totalStar / totalCmt);
        nAvg = (totalStar / totalCmt).toFixed(1);
        document.getElementById("avg-star-lob").innerHTML = nAvg;
        getStarDetail();
    } else {
        n = 0;
    }

    document.getElementById("total-cmt").innerHTML = totalCmt + " đánh giá";
    let star = ``
    for (var i = 1; i <= n; i++) {
        star += `<i id="star-i" class="fa fa-star" style="color: #fe8b23" aria-hidden="true"></i>`
    }
    var step = 1;
    if (nAvg - n > 0.25 && nAvg - n < 0.75) {
        star += `<i id="star-i" class="fa fa-star-half-o" style="color: #fe8b23;" aria-hidden="true"></i>`
        step = 2;
    } else if (nAvg - n > 0.75) {
        star += `<i id="star-i" class="fa fa-star" style="color: #fe8b23" aria-hidden="true"></i>`
        step = 2;
    }
    for (var i = n + step; i <= 5; i++) {
        star += `<i id="star-i" class="fa fa-star" style="color: #cacaca;" aria-hidden="true"></i>`
    }
    document.getElementById("avg-star-icon").insertAdjacentHTML('beforeend', star)
}

function getStarDetail() {
//    lay so binh theo sao
    var x = location.href
    var lob_id = x.slice(x.indexOf('?id=') + 4)
    fetch("/api/get-list-star-detail", {
        method: 'post',
        body: JSON.stringify({
            "lob_id": lob_id
        }),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(function (res) {
        console.info(res);
        return res.json();
    }).then(function (data) {
        showTotalStarDetail(data)
    });
}

function showTotalStarDetail(data) {
    $('div').remove('#flag-detail-star');
    let ds = ``;
    for (var i = 1; i <= 5; i++) {
        var toltalS = 0;
        var widthStar = 0;
        for (var j = 0; j < data.length; j++)
            if (data[j][0] == i) {
                toltalS = data[j][1];
                widthStar = (toltalS / totalCmt) * 100;
                
                break;
            }
        ds += `<div id="flag-detail-star" style="display: flex;">
                <span style="color:#5b5b5b">${i} <i class="fa fa-star" style="color:black" aria-hidden="true"></i></span>
                <div style="background-color: #eee;height: 4px;position: relative;width: 220px;margin-top: 10px;margin-left: 5px;">
                    <span style="display: block;background-color: #fe8c23;height: 4px;width:${widthStar}%"></span>
                </div>
                <span style="margin-left:7px;font-weight: initial;">${toltalS} đánh giá</span>
            </div>`
    }
    document.getElementById("star-detail").insertAdjacentHTML('beforeend', ds);
}

function showListComment(data) { 
    showAvgStars();
    let lc = ``;
    if (data.length > 0) {
        $('div').remove('#more-cmt');
        for (var i = 0; i < data.length; i++) {
            var date = new Date(data[i][4])
            date.toLocaleString()
            let stars = ``;
            for (var j = 1; j <= data[i][2]; j++) {
                stars += `<i class="fa fa-star" style="color: #fe8b23; margin-right:3px;" aria-hidden="true"></i>`
            }
            for (var j = data[i][2] + 1; j <= 5; j++) {
                stars += `<i class="fa fa-star" style="color: #cacaca; margin-right:3px;" aria-hidden="true"></i>`
            }
            let content = data[i][3]
            let style = ``;
            if (content.length > 270) {
                style = `display: -webkit-box;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 3;
            overflow: hidden; `
            }
            lc += `<div id="flag-cmt" style="border-bottom: 1px solid #f1f1f1;margin-top:15px">
                    <p style="font-weight: bold;margin-right: 8px;">${data[i][1]['userLastName'] + ' ' + data[i][1]['userFirstName']}
                        <span style="margin-left: 25px;font-weight: normal;">${date.getMinutes() + ":" + date.getHours() +
                    " - " + date.getDate() + "/" + date.getMonth() + "/" + date.getFullYear() }</span>
                    </p>
                    <div style="margin-bottom: 10px">
                        ${stars}
                    </div>
                    <p id="content${data[i][0]}" style = "${style}">${content}</p>`
            if (style != "")
                lc += `<div id="${data[i][0]}" style="text-align: center;color: #f05d3b;margin-bottom: 15px;" onclick="showReadMore(this)">
                            <span style=" cursor: pointer" >Đọc thêm </span>
                        </div>`
            lc += `</div>`
        }
        document.getElementById("list-comment").insertAdjacentHTML('beforeend', lc)
        if (xCmt * 2 < totalCmt) {
            let more = `<div id="more-cmt" style="text-align: center;color: blue">
                <span style=" cursor: pointer" onclick="getListCmtByLobbyId()">Xem thêm <i class="fa fa-angle-double-down" aria-hidden="true"></i></span>
            </div>`
            document.getElementById("list-comment").insertAdjacentHTML('beforeend', more)
        }
    } else {
        lc = `<div  id="flag-cmt" style="padding: 30px;"><i>Chưa có đánh giá nào</i></div>`
        document.getElementById("list-comment").insertAdjacentHTML('beforeend', lc)
    }
}

function showReadMore(element) {
    element.style.display = "none"
    document.getElementById("content"+element.id).style.display = "block"
}