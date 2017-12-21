-module(testcities).
-compile([export_all, nowarn_export_all]).
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/wf.hrl").

main() ->
  Body = #dtl{file = "testcities", app=ublog,bindings=[
    {citiestext, <<"Міста:"/utf8>>},
    {citiesshowtext, <<"Оновити список міст"/utf8>>},
    {citiesaddtext, <<"Додати місто в список:"/utf8>>},
    {citynametext, <<"Назва міста"/utf8>>},
    {citypoptext, <<"Населення міста"/utf8>>},
    {citiesaddtext, <<"Додати місто"/utf8>>} ]},
  
  #dtl{file = "layout", app=ublog,bindings=[
    {mytitle, <<"Тест - міста"/utf8>>},
    {mycss, <<"<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/test.css\">">>},
    {mybody, wf:render(Body)},
    {myjs, <<"<script src=\"/js/testcities.js\" defer></script>">>} ]}.


event(init) ->
  ?MODULE:event({client,{sitiesshow}});
  %[];


event({client,{sitiesshow}}) ->
  Mpid = pg:mypg(),
  Data = pq:get_all_cities(Mpid),
  epgsql:close(Mpid),
  
  InnerHtml = hg:generate_cities_list(Data),
  
  wf:wire(wf:f("var parent = qi('cities');"
          "parent.innerHTML='~s';"
          "window.getting_data=false;"
          "qi('citiesshow').disabled=false;",[unicode:characters_to_binary(InnerHtml,utf8)]));


event({client,{cityadd, Name, Pop}}) ->
  %io:format("~p~n~p~n",[Name, Pop]),
  Mpid = pg:mypg(),
  1 = pq:add_city(Mpid, Name, Pop),
  epgsql:close(Mpid),
  
  wf:wire(wf:f("qi('cityname').value='';"
          "qi('citypop').value='1';"
          "window.sending_data=false;"
          "qi('cityadd').disabled=false;",[])),
  ?MODULE:event({client,{sitiesshow}});


event(Event) ->
  wf:info(?MODULE,"Event: ~p", [Event]),
  ok.

