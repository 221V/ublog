-module(test_timer).
-compile([export_all, nowarn_export_all]).

-include_lib("n2o/include/wf.hrl").


% test timer with n2o_async module

% #handler { name   = [] :: [] | term(),
%            module = [] :: [] | atom(),
%            class  = [] :: [] | atom(),
%            group  = [] :: [] | atom(),
%            config = [] :: [] | term(),
%            state  = [] :: [] | term() }.

%Name — process name, key in supervised chain.
%Module — the module name where proc/2 is placed.
%Class — ETS table name where cached pids are stored.
%Group — the application, where supervised processes will be created.
%Config — any term used to start the supervised procedd.
%State — the state of the running supervised process.

% just put test_timer:start() where your app starts

proc(init,#handler{}=Async) ->
  {ok,Async#handler{state=timer(1)}};

proc({timer,ping, X},#handler{state=_Timer}=Async) ->
  io:format("n2o Timer: ~p\r~n",[X]),
  {reply,ok,Async#handler{state=timer(X)}}.

timer(X) ->
  erlang:send_after(5000, self(), {timer, ping, X + 1}).


start() ->
  n2o_async:start(#handler{ module=test_timer,
                            class=caching,
                            group=n2o,
                            state=[],
                            name="timer"}).


