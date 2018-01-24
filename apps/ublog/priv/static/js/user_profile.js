

function do_login_bind(){
  qi('do_login').addEventListener("click", function(){
    var l = qi('login').value;
    var p = qi('pass').value;
    if((l != '') && (p != '')){
      var timerId = setTimeout(function tick(){
      if(window.active){
        window.login_wait = true;
        ws.send(enc(tuple( atom('client'), tuple(atom('login'), utf8_toByteArray(l), utf8_toByteArray(p) ) )));
      }else{
        timerId = setTimeout(tick, 200);
      }
      }, 100);
    }else{
    alert('login or pass can\'t be empty string !');
    }
  });
}

function textareas_init(){
  textarea_preview_post = qi('bb_preview_post');
  sceditor.create(textarea_preview_post, {
  format: 'bbcode',
  icons: 'monocons',
  style: '/css/sceditor-default.min.css'
  });
  textarea_post = qi('bb_post');
  sceditor.create(textarea_post, {
  format: 'bbcode',
  icons: 'monocons',
  style: '/css/sceditor-default.min.css'
  });
}

function tags_and_validation(){
  var tags = document.getElementsByName('selectedtag');
  var checked_ids = '';
  var count_checked = 0;
  tags.forEach(function(el){ if(el.checked){
      if(count_checked == 0){ checked_ids = checked_ids + el.value; }else{ checked_ids = checked_ids + ',' + el.value; }
      count_checked++;}
  });
  return [count_checked, checked_ids];
}

function tags_to_checked(a){
  var tags_ids = a.split(",");
  var tags = document.getElementsByName('selectedtag');
  tags.forEach(function(el){
    if(tags_ids.indexOf(el.value) != -1){ el.checked = true; }
  });
}

function do_addpost_bind(){
  qi('addnewpost').addEventListener("click", function(){
    
    var title = qi('title_post').value;
    var title_valid = (title !== '');
    var preview_post = sceditor.instance(textarea_preview_post).getWysiwygEditorValue();
    var post = sceditor.instance(textarea_post).getWysiwygEditorValue();
    var preview_post_valid = (preview_post !== '');
    var post_valid = (post !== '');
    var tags_and_valid = tags_and_validation();
    var tags_valid = (tags_and_valid[0] >= 2) && (tags_and_valid[0] <= 7);
    
    if(title_valid && preview_post_valid && post_valid && tags_valid){
      var timerId = setTimeout(function tick(){
      if(window.active){
        if(window.send_wait !== true){
          window.send_wait = true;
          ws.send(enc(tuple( atom('client'), tuple(atom('post'), querySource('title_post'), utf8_toByteArray(preview_post), utf8_toByteArray(post), utf8_toByteArray(tags_and_valid[1]) ) )));
        }
      }else{
        timerId = setTimeout(tick, 200);
      }
      }, 100);
    }else{
      if((title_valid && preview_post_valid && post_valid) !== true){alert('title, post and/or preview can not be empty !');}
      if(tags_valid !== true){alert('please select 2 or more (up to 7) tags !');}
    }
    
  });
}

function do_editpost_bind(){
  qi('editpost').addEventListener("click", function(){
    
    var title = qi('title_post').value;
    var title_valid = (title !== '');
    var preview_post = sceditor.instance(textarea_preview_post).getWysiwygEditorValue();
    var post = sceditor.instance(textarea_post).getWysiwygEditorValue();
    var preview_post_valid = (preview_post !== '');
    var post_valid = (post !== '');
    var tags_and_valid = tags_and_validation();
    var tags_valid = (tags_and_valid[0] >= 2) && (tags_and_valid[0] <= 7);
    
    if(title_valid && preview_post_valid && post_valid && tags_valid){
      var timerId = setTimeout(function tick(){
      if(window.active){
        if(window.send_wait !== true){
          window.send_wait = true;
          ws.send(enc(tuple( atom('client'), tuple(atom('post'), querySource('title_post'), utf8_toByteArray(preview_post), utf8_toByteArray(post), utf8_toByteArray(tags_and_valid[1]) ) )));
        }
      }else{
        timerId = setTimeout(tick, 200);
      }
      }, 100);
    }else{
      if((title_valid && preview_post_valid && post_valid) !== true){alert('title, post and/or preview can not be empty !');}
      if(tags_valid !== true){alert('please select 2 or more (up to 7) tags !');}
    }
    
  });
}

/*function do_testpost_bind(){
  qi('testnewpost').addEventListener("click", function(){
    var preview_post = sceditor.instance(textarea_preview_post).getWysiwygEditorValue();
    var post = sceditor.instance(textarea_post).getWysiwygEditorValue();
    var preview_post_valid = (preview_post !== '');
    var post_valid = (post !== '');
    var tags_and_valid = tags_and_validation();
    var tags_valid = (tags_and_valid[0] >= 2) && (tags_and_valid[0] <= 7);
    
    if(preview_post_valid && post_valid && tags_valid){
      var timerId = setTimeout(function tick(){
      if(window.active){
        if(window.send_wait !== true){
          window.send_wait = true;
          ws.send(enc(tuple( atom('client'), tuple(atom('test_post'), utf8_toByteArray(preview_post), utf8_toByteArray(post), utf8_toByteArray(tags_and_valid[1]) ) )));
        }
      }else{
        timerId = setTimeout(tick, 200);
      }
      }, 100);
    }else{
      if((preview_post_valid && post_valid) !== true){alert('post and/or preview can not be empty !');}
      if(tags_valid !== true){alert('please select 2 or more (up to 7) tags !');}
    }
    
  });
}*/

function check_logout(){
  if(location.hash == '#logout'){logout();}
}

function logout(){
  var timerId = setTimeout(function tick(){
    if(window.logouting !== true){
    if(window.active){
      window.logouting = true;
      ws.send(enc(tuple( atom('client'), tuple(atom('logout') ) )));
    }else{
      timerId = setTimeout(tick, 200);
    }
    }
  }, 100);
}


if(window.active){
  setTimeout(check_logout, 100);
}


window.addEventListener("load", function load1(e0){

if(qi('do_login')){
  do_login_bind();
}


},false);

