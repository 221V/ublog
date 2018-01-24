-module(routes).
-author('Maxim Sokhatsky').
-include_lib("n2o/include/wf.hrl").
-export([init/2, finish/2]).

%% U can use default dynamic routes or define custom static as this
%% Just put needed module name to sys.config:
%% {n2o, [{route,routes}]}
%% Also with dynamic routes u must load all modules before starting Cowboy
%% [code:ensure_loaded(M) || M <- [index, login, ... ]]

finish(State, Ctx) -> {ok, State, Ctx}.
init(State, Ctx) ->
    Path = wf:path(Ctx#cx.req),
    wf:info(?MODULE,"Route: ~p~n",[Path]),
    {ok, State, Ctx#cx{path=Path,module=route_prefix(Path)}}.

route_prefix(<<"/ws/",P/binary>>) -> route(P);
route_prefix(<<"/",P/binary>>) -> route(P);
route_prefix(P) -> route(P).

%route(<<>>)              -> login;
%route(<<"testcities/">>) -> testcities;
%route(<<"index",_/binary>>) -> index;
route(<<"login/">>) -> login;
route(<<"profile/">>) -> profile;
route(<<"profile/posts/">>) -> profile_posts;
route(<<"profile/posts/add/">>) -> add_post;
route(<<"profile/posts/edit/">>) -> edit_post;
route(_) -> redirect_to_main.

