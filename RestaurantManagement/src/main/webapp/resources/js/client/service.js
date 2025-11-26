var flag = 1;
var id = 2;
function loadService() {
    fetch(`/api/service/${id}`).then(res => res.json()).then(data => {
        showService(data)
    })
}

window.addEventListener('scroll', () => {
    var myElement = document.getElementById('flag-scroll');
    var topPos = myElement.offsetTop;
    if (window.scrollY + window.innerHeight >= topPos && flag === 1) {
        flag = 0;
        loadService()
        id += 1;
    }
})

function showService(data) {
    if (data != null) {
        let service = `
        <h4 class="">${data.serName}</h4>
        <hr/>
        <div class="row">
            <div class="col-md-8">
                <img style="width: 100%; height: 400px;" src="${data.serImage}"  alt="Thành Văn">
            </div>
            <div class="col-md-4 text-des">
                <div style="font-size: 25px; color: #e58946; margin-bottom: 20px;">GIÁ: 
                    ${format(data.serPrice)} ₫</div>
                <div>${data.serDescription}</div>
            </div>
        </div><br/>
        <hr style="width: 100%; border-width: 2px; background-color: #fff "/>`
        document.getElementById("service-show").insertAdjacentHTML('beforeend', service)
        flag =1;
    }
}

function format(n) {
    return n.toFixed(0).replace(/./g, function (c, i, a) {
        return i > 0 && c !== "." && (a.length - i) % 3 === 0 ? "." + c : c
    })
}