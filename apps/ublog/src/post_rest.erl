-module(post_rest).
-export([init/3, allowed_methods/2, content_types_provided/2, resource_exists/2]).
-export([paste_html/2]).

init(_Transport, _Req, []) ->
  {upgrade, protocol, cowboy_rest}.

allowed_methods(Req, State) ->
  {[<<"GET">>], Req, State}.

content_types_provided(Req, State) ->
  %io:format("state resource0: ~tp~n",[State]), % undefined
  {[
    %{{<<"text">>, <<"html">>, []}, paste_html}
    {{<<"text">>, <<"html">>, '*'}, paste_html} %default
    %{{<<"text/html">>}, paste_html}
  ], Req, State}.


resource_exists(Req, _State) ->
  %io:format("req1 resource: ~tp ~n",[Req]),
  %wf:init_context(Req),
  %io:format("req cookies resource: ~tp ~n",[cowboy_req:cookies(Req)]),
  %{Cookies,_Req02} = cowboy_req:cookies(Req),
  %io:format("req cookies2 resource: ~tp ~n",[ets:tab2list(cookies)]),
  %io:format("req cookies1 resource: ~tp ~n",[Cookies]),
  %io:format("req cookies3 resource: ~tp ~n",[n2o_cowboy:cookie(<<"site-sid">>, Req)]), % <<"f49c52609690292cc4ee41e1238c4e72">>
  %SessionCookie = n2o_cowboy:cookie(<<"site-sid">>, Req), %get cookie value by key
  %io:format("req cookies4 resource: ~tp ~n",[n2o_session:lookup_ets({SessionCookie, <<"auth">>})]),
  %io:format("req cookies5 resource: ~tp ~n",[n2o_session:lookup_ets({SessionCookie, <<"user">>})]),
  %io:format("req cookies6 resource: ~tp ~n",[n2o_session:lookup_ets({SessionCookie, uid})]),
  %io:format("req cookies7 resource: ~tp ~n",[n2o_session:lookup_ets({SessionCookie, testzzz})]),
  
  %io:format("req cookies8 resource: ~tp ~n",[hm:get_session_value(<<"auth">>,Req)]), % new|undefined % logged|not logged
  %io:format("req cookies9 resource: ~tp ~n",[hm:get_session_value(<<"user">>,Req)]), % <<"binary">>|undefined
  %io:format("req cookies10 resource: ~tp ~n",[hm:get_session_value(uid,Req)]), % integer|<<"binary">>|undefined % integer or binary if we put there integer or binary
  
  %io:format("post id resource: ~tp~n",[cowboy_req:binding(id, Req)]), % {<<"integer">>,Req} | {undefined,Req}
  
  case cowboy_req:binding(id, Req) of
    {undefined, Req2} ->
      %{false, Req2, <<"error 404, not found">>};
      % post id not found -- redirect to main
      %{ok, Req3} = cowboy_req:reply(303, [{<<"location">>, <<"/">>}], <<"">>, Req2),
      %{false, Req3, []};
      %{true, Req3, []};
      %{ok, Req3, []};
      cowboy_req:reply(303, [{<<"location">>, <<"/">>}], Req2),
      {shutdown, Req2, []};
    {Post_id, Req2} ->
      {true, Req2, Post_id}
  end.


paste_html(Req, Post_Id) ->
  %io:format("post id: ~p~n",[Post_Id]), % post id: <<"2">>
  
  %Html = <<"<!DOCTYPE html><html>",
  %"<head><title>paste</title></head>",
  %"<body><pre><code>", Paste2/binary, "</code></pre></body></html>">>,
  
  % ../priv/templates/testrest.html -> testrest_view.beam
  %{ok, Html} = testrest_view:render([ {title, <<"example">>}, {text, Post_Id} ]),
  %{Html, Req, []}.
  
  Mpid = pg:mypg(),
  case pq:get_post_by_id(Mpid, erlang:binary_to_integer(Post_Id)) of
    [{_Author_Id, Title, _, _, _, Html_Post, Tags, Inserted_At}] ->
      %io:format("post tags: ~tp ~n",[Tags]), % [3,1]
      Tags2 = lists:foldl(fun(X,"") -> erlang:integer_to_list(X);(X,Acc) -> erlang:integer_to_list(X) ++ "," ++ Acc end, "", Tags),
      Tags3 = pq:get_value_tags_in(Mpid, Tags2),
      
      Header = case hm:get_session_value(<<"user">>,Req) of
        undefined -> <<"<div class=\"header\"><a href=\"/page/1\" title=\"Main\"><span>ublog</span></a></div>">>;
        Nickname ->
          Uid = hm:get_session_value(uid,Req),
          [{Posts_Count}] = pq:get_user_posts_count(Mpid, Uid),
          hg:generate_user_profile_menu(Uid, Nickname, Posts_Count)
      end,
      All_Tags = pq:get_tags_orderby_countposts(Mpid),
      All_Tags2 = hg:generate_tags_cloud(All_Tags,[]),
      epgsql:close(Mpid),
      
      Post = hg:generate_full_post(Title, Tags3, Html_Post, Inserted_At),
      {ok, Html} = post_rest_view:render([ {title, Title}, {header, Header}, {tags_cloud, All_Tags2}, {post, Post} ]),
      
      {Html, Req, []};
    [] ->
      % post not found -- redirect to main
      epgsql:close(Mpid),
      {ok, Req2} = cowboy_req:reply(303, [{<<"location">>, <<"/">>}], Req),
      {<<"">>, Req2, []};
    _ ->
      epgsql:close(Mpid),
      {<<"<p>database error</p>">>, Req, []}
  end.


