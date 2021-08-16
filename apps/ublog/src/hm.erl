-module(hm).
-compile([export_all, nowarn_export_all]).

%-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/wf.hrl").
%-include_lib("kernel/include/file.hrl").

%help module


%% validations

% is_valid_email(A)

%% trim

% trim(Bin)
% trim_l(List)

%% input data changing

% htmlspecialchars(String) % & -> &amp;, " -> &quot;, ' -> &apos;, < -> &lt;, > -> &gt;
% tags_to_values(Data,Acc)

%% other

% get_session_value(Key,Req)
% timestamp2binary({{Year,Month,Day},{Hour,Minit,_}})
% hash_pass(A)
% =================


%% validations


is_valid_email(A) ->
  %case re:run(A, "^[a-z0-9_-]+(\.[a-z0-9_-]+)*@([0-9a-z][0-9a-z-]*[0-9a-z]\.)+([a-z]{2,8})$") of
  case re:run(A, "^(.)+@(.)+\.(.+)$") of
    nomatch -> false;
    _ -> true
  end.


%% trim


%trim binary
trim(<<>>) -> <<>>;
trim(Bin = <<C,BinTail/binary>>) ->
  case ?MODULE:is_whitespace(C) of
    true -> ?MODULE:trim(BinTail);
    false -> ?MODULE:trim_tail(Bin)
  end.

trim_tail(<<>>) -> <<>>;
trim_tail(Bin) ->
  Size = erlang:size(Bin) - 1,
  <<BinHead:Size/binary,C>> = Bin,
  case ?MODULE:is_whitespace(C) of
    true -> ?MODULE:trim_tail(BinHead);
    false -> Bin
  end.

%helper - trim symbols
is_whitespace($\s) -> true;
is_whitespace($\t) -> true;
is_whitespace($\n) -> true;
is_whitespace($\r) -> true;
is_whitespace(_) -> false.

%trim list
trim_l("") -> "";
trim_l(List=[H|T]) ->
  case ?MODULE:is_whitespace(H) of
    true -> ?MODULE:trim_l(T);
    false -> ?MODULE:trim_tail_l(lists:reverse(List))
  end.

trim_tail_l("") -> "";
trim_tail_l(List=[H|T]) ->
  case ?MODULE:is_whitespace(H) of
    true -> ?MODULE:trim_tail_l(T);
    false -> lists:reverse(List)
  end.


%% input data changing


htmlspecialchars(String) ->
  unicode:characters_to_binary( [?MODULE:htmlspecialchars2(X) || X <- String], utf8, latin1).

%helper
% & -> &amp;, " -> &quot;, ' -> &apos;, < -> &lt;, > -> &gt;
htmlspecialchars2($&) -> "&amp;";
htmlspecialchars2($") -> "&quot;";
%htmlspecialchars2($') -> "&apos;";
htmlspecialchars2($') -> "&#39;";
htmlspecialchars2($<) -> "&lt;";
htmlspecialchars2($>) -> "&gt;";
htmlspecialchars2($|) -> "&#124;";
htmlspecialchars2($`) -> "&#96;";
htmlspecialchars2($\\) -> "\\\\"; %" fix for code "\x -> .." - "malformed hexadecimal character escape"
htmlspecialchars2(A) -> A.


%tags_to_values(Data,Acc) ->
tags_to_values([],Acc) -> Acc;
tags_to_values([H],Acc) ->
  case re:run(H, "^[0-9]{1,}$") of
    nomatch -> Acc;
    _ ->
      case Acc of
        "" -> H;
        _ -> H ++ "," ++ Acc
      end
  end;
tags_to_values([H|T],Acc) ->
  case re:run(H, "^[0-9]{1,}$") of
    nomatch -> ?MODULE:tags_to_values(T,Acc);
    _ ->
      case Acc of
        "" -> ?MODULE:tags_to_values(T,H);
        _ -> ?MODULE:tags_to_values(T,H ++ "," ++ Acc)
      end
  end.


%% other


get_session_value(Key,Req) ->
  SessionCookie = n2o_cowboy:cookie(<<"site-sid">>, Req),
  ?MODULE:get_session_value2(n2o_session:lookup_ets({SessionCookie, Key})).

%helper
get_session_value2({_, _, _, _, A}) -> A;
get_session_value2(_) -> undefined.


%{{2017,10,18},{12,29,50.0}}
timestamp2binary({{Year,Month,Day},{Hour,Minit,_}}) ->
  [erlang:integer_to_binary(Year), <<"/">>, ?MODULE:make_valid_day(Month), <<"/">>, ?MODULE:make_valid_day(Day), <<" ">>, ?MODULE:make_valid_day(Hour), <<":">>, ?MODULE:make_valid_day(Minit)].

%helper
make_valid_day(Data) when Data < 10 ->
  [<<"0">>, erlang:integer_to_binary(Data)];
make_valid_day(Data) ->
  erlang:integer_to_binary(Data).


%make hash pass
hash_pass(A) ->
  S1 = <<"Some хороша salt!\"@#ф$%5^&*()=="/utf8>>,
  S2 = <<"yeah ___________<>(c)2018++ lol"/utf8>>,
  A2 = erlang:list_to_binary(A),
  [ erlang:element(C+1, {$0,$1,$2,$3,$4,$5,$6,$7,$8,$9,$A,$B,$C,$D,$E,$F}) || <<C:4>> <= crypto:hash(sha512, <<S1/binary,A2/binary,S2/binary>>)].




