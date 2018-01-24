

// /profile/posts/#/uid/:uid/page/:page_num

//window.addEventListener("load", function load2(e0){

var route = {
  path: '#/uid/:uid/page/:page_num',
  on: function(){
    
    var uid = parseInt(this.params.uid);
    var page_num = parseInt(this.params.page_num);
    var is_valid = (Number.isInteger(uid) && (uid > 0)) && (Number.isInteger(page_num) && (page_num > 0));
    
    if(is_valid){
    var timerId = setTimeout(function tick(){
    if(window.wait_page !== true){
      if(window.active){
        window.wait_page = true;
        ws.send(enc(tuple( atom('client'), tuple(atom('get_page_posts'), utf8_toByteArray('' + uid), utf8_toByteArray('' + page_num) ) )));
      }else{
        if(window.wait_page !== true){
        timerId = setTimeout(tick, 200);
        }
      }
    }else{
      timerId = setTimeout(tick, 200);
    }
    }, 100);
    }else{
    window.location.replace('/');
    }
    
  }
};
Router.add(route);

//Router.init();

var onNotFound = function(){
  if(window.uid){
  Router.navigate('#/uid/' + window.uid + '/page/1');
  }else{
  window.location.replace('/');
  }
}
Router.init(null,onNotFound);


//},false);

