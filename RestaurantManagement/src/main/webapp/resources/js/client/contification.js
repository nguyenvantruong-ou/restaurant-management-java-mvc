let listUnread = {};
let listAll = {};

$("#noti-feed").ready(function () {
    unreadFeedbackByUsername();
    countUnread();
    getAllFeedback(); //update
});

//dem contiffication chua doc
function countUnread() {
    fetch("/api/count-contification", {
        method: 'post',
        body: JSON.stringify({
        }),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(function (res) {
        console.info(res);

        return res.json();
    }).then(function (data) {
        showContification(data);
    });
}

function showContification(number) {
    document.getElementById("count-conti").innerHTML = number;
}

$("#list-username").ready(function () {
    getListUserContiRead();
//    document.getElementById("text-search").value = "";
});

//lay danh sach tat ca cac user phan hoi
function  getListUserContiRead() {
    fetch("/api/username-in-feedback", {
        method: 'post',
        body: JSON.stringify({
            "kw": ""
        }),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(function (res) {
        console.info(res);

        return res.json();
    }).then(function (data) {
        showListUser(data);
        listAll = data;
    });
}

function showListUser(data) {
    let user = ``;
    for (let i = 0; i < data.length; i++) {
        let name = data[i][1]['userUsename'];
        if (name.length > 18) {
            name = name.slice(0, 15) + "...";
        }

        let content = "";
        for (var j = 0; j < listAllFeedback.length; j++)
            if (listAllFeedback[j][2] == data[i][1]['userUsename']) {
                content = listAllFeedback[j][1];
                break;
            }
//        let content = data[i][2];

        if (content.length > 18) {
            content = content.slice(0, 15) + "...";
        }
        var number = 0;
        for (let j = 0; j < listUnread.length; j++) {
            if (data[i][1]['userUsename'] == listUnread[j][1]) {
                number = listUnread[j][2];
                break;
            }
        }
        user += `<div id="flag" class="row" onclick="getFeedbackByUsername('${name}')">
                    <div class="col-lg-3">
                        <img class="img"  src="${data[i][1]['userImage']}"/>
                    </div>
                    <div class="col-lg-7">
                        <div class="username" style="font-weight: bold;">${name}</div>
                        <div>${content}</div>
                    </div>`
        if (number != 0) {
            user += `    <div id="unread${name}" class="col-lg-2" style="padding: 15px;">
                        <span id="count-conti" style="background: red; color: white; padding: 2px 4px; border-radius: 15px">${number}</span>
                    </div>
                </div> `
        } else
            user += `</div> `
    }
    document.getElementById("list-username").insertAdjacentHTML('beforeend', user)
}


//dem so phan hoi chua doc
function  unreadFeedbackByUsername() {
    fetch("/api/unread-feedback-by-username", {
        method: 'post',
        body: JSON.stringify({
        }),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(function (res) {
        console.info(res);

        return res.json();
    }).then(function (data) {
        listUnread = data;
    });
}

var flagSearch = 1;

//tim kiem
function searchFeedback(element) {
    let text = element.value;
    if (flagSearch == 1) {
        setDeleteData();
        getListUserContiByKw(text.trim());
    }
}

//lay danh sach tat ca cac user phan hoi
function  getListUserContiByKw(kw) {
    flag = 0;
    fetch("/api/username-in-feedback", {
        method: 'post',
        body: JSON.stringify({
            "kw": kw
        }),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(function (res) {
        console.info(res);

        return res.json();
    }).then(function (data) {
        showListUser(data);
        flagSearch = 1;
    });
}

// Xóa
function setDeleteData() {
    $('div').remove('#flag');
}

//lay danh danh feedback theo username
function  getFeedbackByUsername(username) {
    if (document.getElementById("unread" + username))
        document.getElementById("unread" + username).style.display = "none";
    fetch("/api/feedback-by-username", {
        method: 'post',
        body: JSON.stringify({
            "username": username.trim()
        }),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(function (res) {
        console.info(res);

        return res.json();
    }).then(function (data) {
        showDetailFeedback(data, username.trim());
    })
    setReadFeedback(username);
    deleteListUnread(username);
}

//so phan tu trong listUnread
function deleteListUnread(username) {
    for (var i = 0; i < listUnread.length; i++) {
        if (listUnread[i][1] == username) {
            listUnread.splice(i, 1);
            break;
        }
    }
}

//hien thi chi tiet feeedback
function  showDetailFeedback(data, username) {
    $('div').remove('#flag-detail');
    for (var i = 0; i < listAll.length; i++) {
        if (listAll[i][1]['userUsename'] == username) {
            document.getElementById("name-detail").innerHTML = username
                    + "( " + listAll[i][1]['userLastName'] + " "
                    + listAll[i][1]['userFirstName'] + " )";
            document.getElementById("img-detail").src = listAll[i][1]['userImage'];
        }
    }
    var fb = ``;
    for (var i = 0; i < data.length; i++) {
        let style = "";
        let content = data[i][1];
        if (content.length > 40) {
            style = "width: 85%;"
        }
        fb += `<div id="flag-detail" style="padding: 25px;">
                    <p style="text-align: center; padding: 0;color: #999;margin-top: 20px">08-05-2022</p>
                    <div class="detail" style="${style}">
                        ${data[i][1]}
                    </div>
                </div>`
    }
    document.getElementById("list-feedback").insertAdjacentHTML('beforeend', fb)
    document.getElementById("list-feedback").scrollTop = document.getElementById("list-feedback").scrollHeight;
}

//cap nhat  trang thai
function setReadFeedback(username) {
    fetch("/api/read-feedback", {
        method: 'post',
        body: JSON.stringify({
            "username": username.trim()
        }),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(function (res) {
        console.info(res);

        return res.json();
    }).then(function (data) {
        countUnread();   // cap nhat lai so thong bao chua doc
    })
}


//them ten phuong luc khoi tao
//update

let listAllFeedback = {}
function getAllFeedback() {
    fetch("/api/get-all-list-feedback", {
        method: 'post',
        body: JSON.stringify({
        }),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(function (res) {
        console.info(res);

        return res.json();
    }).then(function (data) {
        listAllFeedback = data
    })
}