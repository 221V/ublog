-module(pg).
-compile([export_all, nowarn_export_all]).


mypg() ->
  %{ok, C} = epgsql:connect("localhost", "user", "pass", [{database, "test"}, {port, 5432}, {timeout, 2000}]),
  Conn = epgsql:connect("localhost", "user", "pass", [{database, "test"}, {port, 6432}, {timeout, 3000}]),
  case Conn of
    {ok, C} ->
      C;
    {error, M} ->
      io:format("Database error: ~p~n", [epgsql_errcodes:to_name(M)]),
      wf:wire(["alert('db conn error!');"]),
      %{error, M}
      error
  end.


transaction(Mpid, Fun) ->
  case epgsql:squery(Mpid, "BEGIN") of
    {ok, _, _} ->
      try
        Result = Fun(),
        epgsql:squery(Mpid, "COMMIT"),
        Result
      catch
        Err1:Err2 ->
          epgsql:squery(Mpid, "ROLLBACK"),
          {Err1, Err2}
      end;
    Error -> Error
  end.

select(Mpid,Q,A) ->
  case epgsql:equery(Mpid, Q, A) of
    {ok,_,R} ->
      R;
    {error,E} ->
      io:format("~p~n", [E]),
      {error,E}
  end.


in_up_del(Mpid,Q,A) ->
  case epgsql:equery(Mpid, Q, A) of
    {ok,R} ->
      R;
    {error,E} ->
      io:format("~p~n", [E]),
      {error,E}
  end.


returning(Mpid,Q,A) ->
  case epgsql:equery(Mpid, Q, A) of
    {ok,1,_,R} ->
      R;
    {error,E} ->
      io:format("~p~n", [E]),
      {error,E}
  end.


