-module(users).
-behaviour(rest).
-compile({parse_transform, rest}).
%-include_lib("kvs/include/user.hrl").
-export([init/0, populate/1, exists/1, get/0, get/1, post/1, delete/1]).

%-ifndef(USER_HRL).
%-define(USER_HRL, true).

%-ifndef(KVS_HRL).
%-define(KVS_HRL, true).

%-define(CONTAINER, id=[], top=[], rear=[], count=0).
-define(ITERATOR(Container), id=[], container=Container, feed_id=[], prev=[], next=[], feeds=[]).

%-record(id_seq,    {thing, id}).
%-record(container, {?CONTAINER}).
%-record(iterator,  {?ITERATOR([])}).
%-record(block,     {left,right,name,last}).
%-record(log,       {?CONTAINER, name, acc}).
%-record(operation, {?ITERATOR(log), body=[], name=[], status=[]}).
%-record(kvs,       {mod,cx}).

%-compile({no_auto_import,[put/2]}).

%-endif.

-ifndef(USER_EXT).
-define(USER_EXT, email=[]).
-endif.

-record(user, {?ITERATOR(feed), ?USER_EXT,
        username=[],
        password=[],
        display_name=[],
        register_date=[],
        tokens = [],
        images=[],
        names=[],
        surnames=[],
        birth=[],
        sex=[],
        date=[],
        status=[],
        zone=[],
        type=[] }).

%-record(user2, {?ITERATOR(feed), % version 2
%        everyting_getting_small,
%        email,
%        username,
%        password,
%        zone,
%        type }).

%-endif.

-rest_record(user).

init()               ->
  ets:new(users, [public, named_table, {keypos, #user.id}]).
populate(Users)      ->
  ets:insert(users, Users).
exists(Id)           ->
  ets:member(users, wf:to_list(Id)).
get()                ->
 ets:tab2list(users).
get(Id)              ->
  #user{id=Id}.
delete(Id)           ->
  ets:delete(users, wf:to_list(Id)).
%post(#user{} = User) -> ets:insert(users, User), true;
post(Data)           ->
  post(from_json(Data, #user{})), true.



