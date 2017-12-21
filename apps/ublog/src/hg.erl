-module(hg).
-compile([export_all, nowarn_export_all]).

%html generate module

% generate_cities_list(Data)
% 

generate_cities_list(Data) ->
  generate_cities_list2(Data, []).

generate_cities_list2([],[]) ->
  <<"<p>Міст ще немає.</p>"/utf8>>;
generate_cities_list2([],Acc) ->
  lists:reverse(Acc);
generate_cities_list2([{_Id,Name,Pop}|T],Acc) ->
  RZ = [<<"<p>"/utf8>>, Name, <<" - населення: "/utf8>>, erlang:integer_to_binary(Pop), <<"</p>"/utf8>>],
  generate_cities_list2(T,[RZ|Acc]);
generate_cities_list2(_,_) ->
  <<"<p>Помилка СУБД!</p>"/utf8>>.

