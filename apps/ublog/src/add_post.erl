-module(add_post).
-compile([export_all, nowarn_export_all]).
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/wf.hrl").

main() -> #dtl{file="null",app=ublog,bindings=[]}.


event(init) ->
  Nickname = wf:user(),
  case Nickname of
    undefined -> wf:redirect("/login/");
    _ ->
      wf:wire("document.title='Add new post';"),
      wf:wire("var load_js=document.createElement('script');load_js.setAttribute('defer','defer');load_js.setAttribute('src', '/js/user_profile.js');document.body.appendChild(load_js);"),
      
      wf:wire("var load_js2=document.createElement('script');load_js2.setAttribute('defer','defer');load_js2.setAttribute('src', '/js/sceditor.min.js');document.body.appendChild(load_js2);"),
      wf:wire("var load_js3=document.createElement('script');load_js3.setAttribute('defer','defer');load_js3.setAttribute('src', '/js/monocons.js');document.body.appendChild(load_js3);"),
      wf:wire("var load_js4=document.createElement('script');load_js4.setAttribute('defer','defer');load_js4.setAttribute('src', '/js/bbcode.js');document.body.appendChild(load_js4);"),
      wf:wire("var load_css=document.createElement('link');load_css.setAttribute('rel', 'stylesheet');load_css.setAttribute('type', 'text/css');load_css.setAttribute('href', '/css/ublog.css');document.body.appendChild(load_css);"),
      wf:wire("var load_css1=document.createElement('link');load_css1.setAttribute('rel', 'stylesheet');load_css1.setAttribute('type', 'text/css');load_css1.setAttribute('href', '/css/sceditor-default.min.css');document.body.appendChild(load_css1);"),
      wf:wire("var load_css2=document.createElement('link');load_css2.setAttribute('rel', 'stylesheet');load_css2.setAttribute('type', 'text/css');load_css2.setAttribute('href', '/css/mybbcodes.css');document.body.appendChild(load_css2);"),
      
      Uid = wf:session(uid),
      Mpid = pg:mypg(),
      [{Posts_Count}] = pq:get_user_posts_count(Mpid, Uid),
      Tags_Data = pq:get_tags_orderby_countposts(Mpid),
      epgsql:close(Mpid),
      P_Menu_HTML = hg:generate_user_profile_menu(Uid, Nickname, Posts_Count),
      P_Form_HTML = hg:generate_user_addpost_form(),
      P_Tags_HTML = hg:generate_user_tags_formpart(Tags_Data, []),
      
      wf:wire(wf:f("var div=document.createElement('div');div.className='row cont';div.innerHTML='~s';"
               "document.body.appendChild(div);"
               "var div2=document.createElement('div');div2.className='addpostform';div2.innerHTML='~s';"
               "document.body.appendChild(div2);", [unicode:characters_to_binary(P_Menu_HTML,utf8), unicode:characters_to_binary(P_Form_HTML,utf8)])),
      
      wf:wire(wf:f("qi('selecttags').innerHTML='~s';",[unicode:characters_to_binary(P_Tags_HTML,utf8)])),
      %wf:wire("setTimeout(function(){ textareas_init();do_addpost_bind();do_testpost_bind(); }, 1000);")
      wf:wire("setTimeout(function(){ textareas_init();do_addpost_bind(); }, 1000);")
      
  end;


%event({client,{test_post, BB_Preview_Post, BB_Post, Tags}}) ->
event({client,{post, Title, BB_Preview_Post, BB_Post, Tags}}) ->
  Valid_Title = erlang:is_list(Title) and (Title =/= ""),
  Valid_Preview = erlang:is_list(BB_Preview_Post) and (BB_Preview_Post =/= ""),
  Valid_Post = erlang:is_list(BB_Post) and (BB_Post =/= ""),
  Valid_Tags1 = erlang:is_list(Tags) and (Tags =/= ""),
  
  Nickname = wf:user(),
  case Nickname of
    undefined -> wf:redirect("/login/");
    _ ->
      Tags2 = string:split(Tags, ",", all),
      Tags2Len = erlang:length(Tags2),
      Valid_Tags2 = (Tags2Len >= 2) and (Tags2Len =< 7),
      
      case (((Valid_Title and Valid_Preview) and Valid_Post) and (Valid_Tags1 and Valid_Tags2)) of
        true ->
          BB_Preview_Post1 = hm:htmlspecialchars(BB_Preview_Post),
          {ok, BB_Preview_Post2, _} = bbcodeslex:string(unicode:characters_to_list(BB_Preview_Post1,utf8)),
          BB_Preview_Post3 = hm:leex_parser(BB_Preview_Post2,[]),
          BB_Post1 = hm:htmlspecialchars(BB_Post),
          {ok, BB_Post2, _} = bbcodeslex:string(unicode:characters_to_list(BB_Post1,utf8)),
          BB_Post3 = hm:leex_parser(BB_Post2,[]),
          
          %wf:wire(wf:f("qi('result_preview_post').innerHTML=`~s`;qi('result_post').innerHTML=`~s`;"
          %  "window.send_wait=false;",[unicode:characters_to_binary(BB_Preview_Post3,utf8), unicode:characters_to_binary(BB_Post3,utf8)]));
          
          Tags2V = hm:tags_to_values(Tags2,""),
          Mpid = pg:mypg(),
          [{Tags2Count}] = pq:get_count_tags_in(Mpid, Tags2V),
          if Tags2Count >= 2 ->
              Tags3 = [ erlang:list_to_integer(TX) || TX <- string:split(Tags2V, ",", all)],
              Title3 = hm:htmlspecialchars(hm:trim_l(Title)),
              UId = wf:session(uid),
              [{PId}] = pq:insert_post(Mpid, UId, Title3, unicode:characters_to_binary(BB_Preview_Post1,utf8), unicode:characters_to_binary(BB_Preview_Post3,utf8), unicode:characters_to_binary(BB_Post1,utf8), unicode:characters_to_binary(BB_Post3,utf8), Tags3),
              pq:update_countposts_tags_in(Mpid, Tags2V),
              
              %wf:redirect("/post/" ++ erlang:integer_to_list(PId));
              wf:wire("window.send_wait=false;alert('ok !');");
            true -> wf:wire("window.send_wait=false;alert('invalid tags !');")
          end,
          epgsql:close(Mpid);
        _ ->
          wf:wire("window.send_wait=false;alert('invalid data !');")
      end
  end;


event({client,{logout}}) ->
  wf:logout(),
  wf:redirect("/");


event(_) -> [].
