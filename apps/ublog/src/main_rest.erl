-module(main_rest).
-export([init/3, allowed_methods/2, content_types_provided/2, resource_exists/2]).
-export([paste_html/2]).

init(_Transport, _Req, []) ->
  {upgrade, protocol, cowboy_rest}.

allowed_methods(Req, State) ->
  {[<<"GET">>], Req, State}.

content_types_provided(Req, State) ->
  {[
    %{{<<"text">>, <<"html">>, []}, paste_html}
    {{<<"text">>, <<"html">>, '*'}, paste_html} %default
    %{{<<"text/html">>}, paste_html}
  ], Req, State}.


resource_exists(Req, _State) ->
  
  %io:format("page num resource: ~tp~n",[cowboy_req:binding(num, Req)]), % {<<"1">>,Req} | {undefined,Req}
  
  case cowboy_req:binding(num, Req) of
    {undefined, Req2} ->
      %{false, Req2, <<"error 404, not found">>};
      %{true, Req2, <<"this is index">>};
      cowboy_req:reply(303, [{<<"location">>, <<"/page/1">>}], Req2),
      {shutdown, Req2, []};
    {Page_Num, Req2} ->
      {true, Req2, Page_Num}
  end.

paste_html(Req, Page_Num) ->
  %Paste2 = escape_html_chars(Page_Num),
  %Html = <<"<!DOCTYPE html><html>",
  %"<head><title>paste</title></head>",
  %"<body><pre><code>", Paste2/binary, "</code></pre></body></html>">>,
  
  % ../priv/templates/testrest.html -> testrest_view.beam
  %{ok, Html} = testrest_view:render([ {title, <<"example">>}, {text, Paste2} ]),
  %{Html, Req, Page_Num}.
  
  Page_Num2 = erlang:binary_to_integer(Page_Num),
  Page_Valid = erlang:is_integer(Page_Num2) and (Page_Num2 > 0),
  
  case Page_Valid of
    true ->
      
      Limit_On_Page = 10,
      [{All_Posts_Count}] = pq:get_all_posts_count(),
      Page_Valid2 = (All_Posts_Count > (Page_Num2 - 1) * Limit_On_Page),
      case Page_Valid2 of
        true ->
          
          Offset = (Page_Num2 - 1) * Limit_On_Page,
          Posts_Data = pq:get_posts_by_page(Limit_On_Page, Offset),
          Posts_Html = hg:generate_page_posts(Posts_Data,[]),
          
          Header = case hm:get_session_value(<<"user">>,Req) of
            undefined -> <<"<div class=\"header\"><a href=\"/page/1\" title=\"Main\"><span>ublog</span></a></div>">>;
            Nickname ->
              Uid = hm:get_session_value(uid,Req),
              [{Posts_Count}] = pq:get_user_posts_count(Uid),
              hg:generate_user_profile_menu(Uid, Nickname, Posts_Count)
          end,
          All_Tags = pq:get_tags_orderby_countposts(),
          All_Tags2 = hg:generate_tags_cloud(All_Tags,[]),
          
          Max_Page = erlang:ceil(All_Posts_Count/Limit_On_Page),
          Pagination_Html = hg:generate_pagination(main, Page_Num2, Max_Page, []),
          
          {ok, Html} = main_rest_view:render([ {title, <<"ublog">>}, {header, Header}, {tags_cloud, All_Tags2}, {posts, Posts_Html}, {pagination, Pagination_Html} ]),
          {Html, Req, []};
        _ ->
          cowboy_req:reply(303, [{<<"location">>, <<"/page/1">>}], Req),
          {shutdown, Req, []}
      end;
    _ ->
      cowboy_req:reply(303, [{<<"location">>, <<"/page/1">>}], Req),
      {shutdown, Req, []}
  end.


