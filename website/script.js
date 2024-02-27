
let info = document.getElementById('info')

// toggle the info box from website name
function toggleInfo(){
    info.style.display = ((info.style.display!='block') ? 'block' : 'none');
}

let subGalleries = document.querySelectorAll('.subGallery')


// close the subGalleries
subGalleries.forEach(subGallery => {
    subGallery.addEventListener('wheel', (evt) => {
        evt.preventDefault();
        subGallery.scrollLeft += evt.deltaY;
    });
    subGallery.addEventListener('click', () =>{
        subGallery.style.display = 'none'
    })
});


function openSubGallery(slug){
    document.getElementById(slug).style.display = 'flex'
    console.log(slug)
}

function changeDescription(slug,name,description){
    document.getElementById('description').innerHTML = '<span>' + name + '</span><span>' + description + '</span>'
}

// create swiper
function swiper(spv){

    const swiper = new Swiper('.swiper', {

        slidesPerView: spv,
        loop: true,
        // Navigation arrows
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
        },
    });

}

// propreties according to the device
var mq = window.matchMedia('(max-width: 800px)');

// spv is n of slides
let spv
if (mq.matches){
    spv = 1
    swiper(spv)

    // description fixed
    document.getElementById('description').style.display = 'block'
    
} else {
    spv = 2
    swiper(spv)

    // description moving
    var segui = document.getElementById('description');

    document.addEventListener('mousemove', function(e) {
        var mx = e.clientX;
        var my = e.clientY;
        segui.style.left = mx + "px";
        segui.style.top = my + "px";
    });


}


function getDataProject(){

    let dataSlug = document.querySelector('.swiper-slide-active img').getAttribute('data-slug')
    let dataName = document.querySelector('.swiper-slide-active img').getAttribute('data-name')
    let dataDescription = document.querySelector('.swiper-slide-active img').getAttribute('data-description')

    changeDescription(dataSlug,dataName,dataDescription)
}

getDataProject()

