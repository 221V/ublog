-module(pq).
-compile([export_all, nowarn_export_all]).

%postgresql queries module

% get_all_cities(Mpid)
% update_city_by_id(Mpid, City_Id, City_Name, City_Pop)
% add_city(Mpid, City_Name, City_Pop)
% add_city_return_id(Mpid, City_Name, City_Pop)
% delete_city_by_id(Mpid, City_Id)
% 


get_all_cities(Mpid) ->
  pg:select(Mpid, "SELECT id, name, population FROM test ORDER BY id", []).


update_city_by_id(Mpid, City_Id, City_Name, City_Pop) ->
  pg:in_up_del(Mpid, "UPDATE test SET name = $1, population = $2 WHERE id = $3", [City_Name, City_Pop, City_Id]).


add_city(Mpid, City_Name, City_Pop) ->
  pg:in_up_del(Mpid, "INSERT INTO test (name, population) VALUES ($1, $2)", [City_Name, City_Pop]).


add_city_return_id(Mpid, City_Name, City_Pop) ->
  pg:returning(Mpid, "INSERT INTO test (name, population) VALUES ($1, $2) RETURNING id", [City_Name, City_Pop]).


delete_city_by_id(Mpid, City_Id) ->
  pg:in_up_del(Mpid, "DELETE FROM test WHERE id = $1", [City_Id]).


  
