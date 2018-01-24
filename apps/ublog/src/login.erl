-module(login).
-compile([export_all, nowarn_export_all]).
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/wf.hrl").

main() -> #dtl{file="login",app=ublog,bindings=[]}.


event(init) ->
  case wf:user() of
    undefined ->
      ok;
    _ ->
      wf:redirect("/profile/")
  end;


event({client,{login, Login, Pass}}) ->
  Valid = ((erlang:is_list(Login) and (Login =/= "")) and hm:is_valid_email(hm:trim_l(Login))) and (erlang:is_list(Pass) and (Pass =/= "")),
  
  case Valid of
    true ->
      
      Email2 = hm:trim_l(Login),
      Mpid = pg:mypg(),
      case pq:get_user_login(Mpid, Email2) of
        [{_, _, _, 3}] -> wf:wire("window.login_wait=false;alert('account deleted !');");
        [{_, _, _, 2}] -> wf:wire("window.login_wait=false;alert('account banned !');");
        [{Uid, Nickname, Password, 1}] ->
          
          Pass2 = hm:trim_l(Pass),
          case Password =:= erlang:list_to_binary(hm:hash_pass(Pass2)) of
            true ->
              
              wf:session(uid, Uid),
              wf:user(Nickname),
              wf:redirect("/profile/");
            _ -> wf:wire("window.login_wait=false;alert('invalid login and/or password !');")
          end;
        [] -> wf:wire("window.login_wait=false;alert('invalid login and/or password !');");
        _ -> wf:wire("window.login_wait=false;alert('db error !');")
      end,
      epgsql:close(Mpid);
    _ ->
      wf:wire("window.login_wait=false;alert('invalid login and/or password !');")
  end;


event(_) -> [].
