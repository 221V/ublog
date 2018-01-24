-module(tag_rest).
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
  
  %io:format("tag id resource: ~tp~n",[cowboy_req:binding(id, Req)]), % {<<"integer">>,Req} | {undefined,Req}
  %io:format("page num resource: ~tp~n",[cowboy_req:binding(num, Req)]), % {<<"integer">>,Req} | {undefined,Req}
  
  {Tag_Id, _} = cowboy_req:binding(id, Req),
  
  case cowboy_req:binding(num, Req) of
    {undefined, Req2} ->
      %{false, Req2, <<"error 404, not found">>};
      %{true, Req2, {<<"">>, <<"this is index">>}};
      case Tag_Id of
        undefined ->
          cowboy_req:reply(303, [{<<"location">>, <<"/page/1">>}], Req2),
          {shutdown, Req2, []};
        _ ->
          cowboy_req:reply(303, [{<<"location">>, <<"/tag/", Tag_Id/binary, "/page/1">>}], Req2),
          {shutdown, Req2, []}
      end;
    {Page_Num, Req2} ->
      case Tag_Id of
        undefined ->
          cowboy_req:reply(303, [{<<"location">>, <<"/page/1">>}], Req2),
          {shutdown, Req2, []};
        _ -> {true, Req2, {Tag_Id, Page_Num}}
      end
  end.

paste_html(Req, {Tag_Id, Page_Num}) ->
  %io:format("tag id: ~p~n",[Tag_Id]),
  %Paste2 = escape_html_chars(Page_Num),
  %Html = <<"<!DOCTYPE html><html>",
  %"<head><title>paste</title></head>",
  %"<body><pre><code>", Paste2/binary, "</code></pre></body></html>">>,
  
  % ../priv/templates/testrest.html -> testrest_view.beam
  %{ok, Html} = testrest_view:render([ {title, <<"example">>}, {text, Paste2} ]),
  %{Html, Req, {Tag_Id, Page_Num}}.
  
  Page_Num2 = erlang:binary_to_integer(Page_Num),
  Page_Valid = erlang:is_integer(Page_Num2) and (Page_Num2 > 0),
  Tag_Id2 = erlang:binary_to_integer(Tag_Id),
  Tag_Id_Valid = erlang:is_integer(Tag_Id2) and (Tag_Id2 > 0),
  
  %io:format("v: ~tp ~tp ~n",[Page_Num2, Tag_Id2]),
  %io:format("vvv: ~tp ~tp ~n",[Page_Valid, Tag_Id_Valid]),
  
  case Page_Valid and Tag_Id_Valid of
    true ->
      
      Limit_On_Page = 10,
      Mpid = pg:mypg(),
      case pq:get_tag_namenposts_count_by_id(Mpid, Tag_Id2) of
        [{Tag_Name, Tag_Posts_Count}] ->
          
          Page_Valid2 = (Tag_Posts_Count > (Page_Num2 - 1) * Limit_On_Page),
          case Page_Valid2 of
            true ->
              
              Offset = (Page_Num2 - 1) * Limit_On_Page,
              Posts_Data = pq:get_posts_by_tag_page(Mpid, erlang:integer_to_list(Tag_Id2), Limit_On_Page, Offset),
              Posts_Html = hg:generate_page_posts(Mpid,Posts_Data,[]),
              
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
              
              Max_Page = erlang:ceil(Tag_Posts_Count/Limit_On_Page),
              Pagination_Html = hg:generate_pagination(tags, Page_Num2, Max_Page, Tag_Id),
              
              {ok, Html} = tag_rest_view:render([ {title, <<Tag_Name/binary, " | ublog">>}, {header, Header}, {tags_cloud, All_Tags2}, {posts, Posts_Html}, {pagination, Pagination_Html} ]),
              {Html, Req, []};
            _ ->
              case Tag_Posts_Count of
                0 ->
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
                  
                  {ok, Html} = tag_rest_view:render([ {title, <<"ublog">>}, {header, Header}, {tags_cloud, All_Tags2}, {posts, [<<"<h2>posts with this tag (">>, Tag_Name, <<") not found</h2>">>]}, {pagination, <<"">>} ]),
                  {Html, Req, []};
                _ ->
                  cowboy_req:reply(303, [{<<"location">>, <<"/tag/", Tag_Id/binary, "/page/1">>}], Req),
                  {shutdown, Req, []}
              end
          end;
        [] ->
            epgsql:close(Mpid),
            cowboy_req:reply(303, [{<<"location">>, <<"/page/1">>}], Req),
            {shutdown, Req, []};
        _ ->
          epgsql:close(Mpid),
          {<<"database error">>, Req, []}
      end;
    _ ->
      case Page_Valid of
        false ->
          cowboy_req:reply(303, [{<<"location">>, <<"/tag/", Tag_Id/binary, "/page/1">>}], Req),
          {shutdown, Req, []};
        _ ->
          cowboy_req:reply(303, [{<<"location">>, <<"/page/1">>}], Req),
          {shutdown, Req, []}
      end
  end.


