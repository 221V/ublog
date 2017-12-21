-module(index).
-compile([export_all, nowarn_export_all]).
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/wf.hrl").

main() ->
    case wf:user() of
         undefined -> wf:redirect("login.htm"), [];
         _ -> #dtl{file = "index", app=ublog,bindings=[{body,body()}]} end.

code() -> case wf:q(<<"code">>) of undefined  -> "none";
                                    Code -> wf:to_list(wf:depickle(Code)) end.

body() ->
    wf:update(heading,#b{id=heading,body="Review: " ++ code()}),
    wf:update(logout,#button{id=logout, body="Logout " ++ wf:user(), postback=logout}),
    [ #span{id=upload},#button { id=send, body= <<"Chat">>, postback=chat, source=[message] } ].

event(init) ->
    %wf:config(n2o,appurl,undefined) %App,Key,DefaulValue
    io:format("~p~n",[wf:config(n2o,appurl,undefined)]),
    
    Room = code(),
    wf:update(upload,#upload{id=upload}),
    wf:reg(n2o_session:session_id()),
    wf:reg({topic,Room});
    %Res = wf:async("looper",fun index:loop/1),
    %n2o_async:send("looper","waterline"),
    %wf:info(?MODULE,"Async Process Created: ~p at Page Pid ~p~n",[Res,self()]);

event(logout) ->
    wf:logout(),
    wf:redirect("login.htm");

event(chat) ->
    User = wf:user(),
    Message = wf:q(message),
    wf:info(?MODULE,"Chat pressed: ~p~n",[Message]),
    Room = code(),
    wf:send({topic,Room},#client{data={User,Message}});

event(#client{data={User,Message}}) ->
    wf:wire(#jq{target=message,method=[focus,select]}),
    HTML = wf:to_list(Message),
    wf:info(?MODULE,"HTML: ~tp~n",[HTML]),
    DTL = #dtl{file="message",app=ublog,bindings=[{user,User},{color,"gray"},{message,HTML}]},
    wf:insert_top(history, wf:jse(wf:render(DTL)));

event(#bin{data=Data}) ->
    wf:info(?MODULE,"Binary Delivered ~p~n",[Data]),
    #bin{data = "SERVER"};

event(#ftp{sid=Sid,filename=Filename,status={event,stop}}=Data) ->
    wf:info(?MODULE,"FTP Delivered ~p~n",[Data]),
    Name = hd(lists:reverse(string:tokens(wf:to_list(Filename),"/"))),
    erlang:put(message,wf:render(#link{href=iolist_to_binary(["/static/",Sid,"/",wf:url_encode(Name)]),body=Name})),
    wf:info(?MODULE,"Message ~p~n",[wf:q(message)]),
    event(chat);

event(Event) ->
    wf:info(?MODULE,"Event: ~p", [Event]),
    ok.

loop(M) ->
    DTL = #dtl{file="message",app=ublog,bindings=[{user,"system"},{message,M},{color,"silver"}]},
    wf:insert_top(history, wf:jse(wf:render(DTL))),
    wf:flush().
