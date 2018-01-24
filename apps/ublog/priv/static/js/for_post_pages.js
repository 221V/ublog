

function detect_left_hight(){
  var elp = document.getElementsByClassName("column left")[0].getBoundingClientRect();
  window.max_little_scroll = elp.bottom + 10;
}

window.scrollTo(0, 0);
window.pg_transformed = false;
detect_left_hight();


window.addEventListener("load", function load1(e0){

if(document.getElementsByClassName("column left")[0] && max_little_scroll){
  window.addEventListener("scroll", function(){
    if((window.pageYOffset > max_little_scroll) && (pg_transformed !== true)){
      document.getElementsByClassName("column left")[0].style.display='none';
      document.getElementsByClassName("column right")[0].style.width='100%';
      window.pg_transformed = true;
    }else if((window.pageYOffset <= max_little_scroll) && (pg_transformed == true)){
      document.getElementsByClassName("column right")[0].style.width='75%';
      document.getElementsByClassName("column left")[0].style.display='block';
      window.pg_transformed = false;
    }
  });
}


},false);

