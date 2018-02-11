-module(profile_posts).
-compile([export_all, nowarn_export_all]).
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/wf.hrl").

main() -> #dtl{file="null",app=ublog,bindings=[]}.


event(init) ->
  Nickname = wf:user(),
  wf:wire("document.title='Posts';"),
  case Nickname of
    undefined ->
      % not logged
      wf:wire("window.uid=false;"),
      
      ok;
    _ ->
      % logged
      wf:wire("var load_js=document.createElement('script');load_js.setAttribute('src', '/js/user_profile.js');document.body.appendChild(load_js);"),
      Uid = wf:session(uid),
      wf:wire(wf:f("window.uid='~s';",[erlang:integer_to_binary(Uid)])),
      [{Posts_Count}] = pq:get_user_posts_count(Uid),
      P_Menu_HTML = hg:generate_user_profile_menu(Uid, Nickname, Posts_Count),
      
      wf:wire(wf:f("var div=document.createElement('div');div.className='row cont';div.innerHTML='~s';"
               "document.body.appendChild(div);", [unicode:characters_to_binary(P_Menu_HTML,utf8)]))
  end,
  wf:wire("var load_js1=document.createElement('script');load_js1.setAttribute('defer','defer');load_js1.setAttribute('src', '/js/hash-router.min.js');document.body.appendChild(load_js1);"),
  wf:wire("var load_js2=document.createElement('script');load_js2.setAttribute('defer','defer');load_js2.setAttribute('src', '/js/user_profile_posts.js');document.body.appendChild(load_js2);");


event({client,{get_page_posts, Uid, Page_Num}}) ->
  io:format("~p ~p ~n", [Uid, Page_Num]),
  ok;


event({client,{logout}}) ->
  wf:logout(),
  wf:redirect("/");


event(_) -> [].
