-module(hg).
-compile([export_all, nowarn_export_all]).

%html generate module

% generate_cities_list(Data)
% 
% generate_user_profile_menu(Uid, Nickname, Posts_Count)
% generate_user_addpost_form()
% generate_user_editpost_form(Title, BB_Preview_Post, BB_Post)
% generate_user_tags_formpart(Tags_Data, Acc)
% generate_tags_url_list(Data,Acc)
% generate_tags_cloud(Data,Acc)
% generate_full_post(Title, Tags3, Html_Post, Inserted_At)
% generate_page_posts(Data, Acc)
% generate_pagination(main|tags, Active_Page, Max_Page, Params)
% 

%generate_cities_list(Data) ->
%  generate_cities_list2(Data, []).

%generate_cities_list2([],[]) ->
%  <<"<p>Міст ще немає.</p>"/utf8>>;
%generate_cities_list2([],Acc) ->
%  lists:reverse(Acc);
%generate_cities_list2([{_Id,Name,Pop}|T],Acc) ->
%  RZ = [<<"<p>"/utf8>>, Name, <<" - населення: "/utf8>>, erlang:integer_to_binary(Pop), <<"</p>"/utf8>>],
%  generate_cities_list2(T,[RZ|Acc]);
%generate_cities_list2(_,_) ->
%  <<"<p>Помилка СУБД!</p>"/utf8>>.


generate_user_profile_menu(Uid, Nickname, Posts_Count) ->
  Uid2 = erlang:integer_to_binary(Uid),
  [ <<"<p class=\"user_profile_menu\"><a href=\"/page/1\">Main</a> | ">>, Nickname, <<" [id:">>, Uid2, <<"] | <a href=\"/profile/posts/#/uid/">>, Uid2, <<"/page/1\">Own posts [">>, erlang:integer_to_binary(Posts_Count), <<"]</a> | <a href=\"/profile/posts/add/\">Add new post</a> | <a href=\"/profile/#logout\" onclick=\"logout();return false\">[Logout]</a></p>">> ].


generate_user_addpost_form() ->
  %[ <<"<textarea id=\"bb_preview_post\">Your post&#39;s previev</textarea><br><br><span>bb_preview_post result (dev info)</span><br><textarea id=\"result_preview_post\"></textarea><br><br><textarea id=\"bb_post\">Your post</textarea><br><br><span>bb_post result (dev info)</span><br><textarea id=\"result_post\"></textarea><br><br><span>Please select 2 or more (up to 7) tags</span><p id=\"selecttags\"></p><br><button id=\"testnewpost\">Test new post</button><br><button id=\"addnewpost\">Add new post</button><br><br>">> ].
  [ <<"<br><br><p>Title:</p><input type=\"text\" id=\"title_post\" placeholder=\"Post title\"><br><br><p>Post preview:</p><textarea id=\"bb_preview_post\">Your post&#39;s previev</textarea><br><br><p>Full post:</p><textarea id=\"bb_post\">Your post</textarea><br><br><span>Please select 2 or more (up to 7) tags</span><p id=\"selecttags\"></p><br><br><br><button id=\"addnewpost\">Add new post</button><br><br>">> ].


generate_user_editpost_form(Title, BB_Preview_Post, BB_Post) ->
  [ <<"<br><br><p>Title:</p><input type=\"text\" id=\"title_post\" placeholder=\"Post title\" value=\"">>, Title, <<"\"><br><br><p>Post preview:</p><textarea id=\"bb_preview_post\">">>, BB_Preview_Post, <<"</textarea><br><br><p>Full post:</p><textarea id=\"bb_post\">">>, BB_Post, <<"</textarea><br><br><span>Please select 2 or more (up to 7) tags</span><p id=\"selecttags\"></p><br><br><br><button id=\"editpost\">Edit post</button><br><br>">> ].


%generate_user_tags_formpart(Tags_Data, Acc)
generate_user_tags_formpart([], Acc) -> lists:reverse(Acc);
generate_user_tags_formpart([{Tag_Id, Tag_Name, Tag_Posts_Count}|T], Acc) ->
  Res = [ <<"<span><label class=\"tag_cast\"><input type=\"checkbox\" name=\"selectedtag\" value=\"">>, erlang:integer_to_binary(Tag_Id), <<"\"><span>">>, Tag_Name, <<" [">>, erlang:integer_to_binary(Tag_Posts_Count), <<"]</span></label></span>">> ],
  ?MODULE:generate_user_tags_formpart(T,[Res|Acc]).


%generate_tags_url_list(Data,Acc)
generate_tags_url_list([],Acc) -> lists:reverse(Acc);
%generate_tags_url_list([{Id, Author_Id, Name, Posts_Count, Inserted_At}|T],Acc) ->
generate_tags_url_list([{Id, _, Name, Posts_Count, _}|T],Acc) ->
  Z = [ <<"<a class=\"tag\" href=\"/tag/">>, erlang:integer_to_binary(Id), <<"/page/1\" target=\"_blank\">">>, Name, <<" [">>, erlang:integer_to_binary(Posts_Count), <<"]</a>">> ],
  ?MODULE:generate_tags_url_list(T,[Z|Acc]);
generate_tags_url_list(_,_) -> <<"tags error">>.


%generate_tags_cloud(Data,Acc)
generate_tags_cloud([],Acc) ->
  [ <<"<div class=\"tags\"><p>Tags</p>">>, lists:reverse(Acc), <<"</div>">> ];
generate_tags_cloud([{Id, Name, Posts_Count}|T],Acc) ->
  Z = [ <<"<a class=\"tag\" href=\"/tag/">>, erlang:integer_to_binary(Id), <<"/page/1\" target=\"_blank\">">>, Name, <<" [">>, erlang:integer_to_binary(Posts_Count), <<"]</a>">> ],
  ?MODULE:generate_tags_cloud(T,[Z|Acc]).


generate_full_post(Title, Tags3, Html_Post, Inserted_At) ->
  Tags = ?MODULE:generate_tags_url_list(Tags3,[]),
  Datetime = hm:timestamp2binary(Inserted_At),
  [ <<"<div class=\"post\"><p class=\"title\">">>, Title, <<"</p><p class=\"tags\">">>, Tags, <<"</p><div class=\"post_body\">">>, Html_Post, <<"</div><span class=\"post_date\">">>, Datetime, <<"</span></div>">> ].


%generate_page_posts(Data, Acc)
generate_page_posts([], Acc) -> lists:reverse(Acc);
generate_page_posts([{Id, _Author_Id, Title, _, Html_Preview_Post, _, _, Tags1, Inserted_At}|T],Acc2) ->
  Tags2 = lists:foldl(fun(X,"") -> erlang:integer_to_list(X);(X,Acc) -> erlang:integer_to_list(X) ++ "," ++ Acc end, "", Tags1),
  Tags3 = pq:get_value_tags_in(Tags2),
  Tags = ?MODULE:generate_tags_url_list(Tags3,[]),
  Datetime = hm:timestamp2binary(Inserted_At),
  Z = [ <<"<div class=\"post\"><p class=\"title\"><a class=\"read_full_post_title\" href=\"/post/">>, erlang:integer_to_binary(Id), <<"\" target=\"_blank\">">>, Title, <<"</a></p><p class=\"tags\">">>, Tags, <<"</p><div class=\"post_body\">">>, Html_Preview_Post, <<"</div><span class=\"post_date\">">>, Datetime, <<"</span><a class=\"read_full_post\" href=\"/post/">>, erlang:integer_to_binary(Id), <<"\" target=\"_blank\"><span>[ Read full post ]</span></a></div>">> ],
  ?MODULE:generate_page_posts(T, [Z|Acc2]).


%generate_pagination(main, Active_Page, Max_Page, Params)
generate_pagination(main, 1, 1, _) ->
  <<"">>;
generate_pagination(main, 1, Max_Page, _) ->
  %first page
  Page_P2 = <<"<a href=\"/page/2\"><button class=\"pagination likegoog paginationbtn\">2</button></a>">>,
  
  case Max_Page of
    2 ->
      Pages_Last = <<"<a href=\"/page/2\"><button class=\"pagination likegoog paginationbtn\">&#x2192;</button></a><a href=\"/page/2\"><button class=\"pagination likegoog paginationbtn\">&#xbb;</button></a>">>;
    _ ->
      
      Page_P3 = <<"<a href=\"/page/3\"><button class=\"pagination likegoog paginationbtn\">3</button></a>">>,
      
      Pages_Last = [Page_P3, <<"<a href=\"/page/2\"><button class=\"pagination likegoog paginationbtn\">&#x2192;</button></a><a href=\"/page/">>, erlang:integer_to_binary(Max_Page), <<"\"><button class=\"pagination likegoog paginationbtn\">&#xbb;</button></a>">>]
  end,
  
  [<<"<button class=\"pagination likegoog paginationactive\">1</button>">>,
  Page_P2, Pages_Last];
generate_pagination(main, Max_Page, Max_Page, _) ->
  %last page
  case Max_Page of
    2 ->
      Page_P1 = <<"<a href=\"/page/1\"><button class=\"pagination likegoog paginationbtn\">1</button></a>">>,
      Page_P2 = <<"">>,
      Pages_Last = <<"">>;
    _ ->
      Page_P1 = [<<"<a href=\"/page/">>, erlang:integer_to_binary(Max_Page - 2), <<"\"><button class=\"pagination likegoog paginationbtn\">">>, erlang:integer_to_binary(Max_Page - 2), <<"</button></a>">>],
      Page_P2 = [<<"<a href=\"/page/">>, erlang:integer_to_binary(Max_Page - 1), <<"\"><button class=\"pagination likegoog paginationbtn\">">>, erlang:integer_to_binary(Max_Page - 1), <<"</button></a>">>],
      Pages_Last = <<"">>
  end,
  
  [<<"<a href=\"/page/1\"><button class=\"pagination likegoog paginationbtn\">&#xab;</button></a>">>,
  <<"<a href=\"/page/">>, erlang:integer_to_binary(Max_Page - 1), <<"\"><button class=\"pagination likegoog paginationbtn\">&#x2190;</button></a>">>,
  Page_P1, Page_P2,
  <<"<button class=\"pagination likegoog paginationactive\">">>, erlang:integer_to_binary(Max_Page), <<"</button>">>,
  Pages_Last];
generate_pagination(main, Active_Page, Max_Page, _) ->
  Count_To_First = (Active_Page =:= 2),
  case Count_To_First of
    true ->
       Pages_First = [<<"<a href=\"/page/1\"><button class=\"pagination likegoog paginationbtn\">&#xab;</button></a><a href=\"/page/1\"><button class=\"pagination likegoog paginationbtn\">&#x2190;</button></a>">>],
       P_1 = <<"<a href=\"/page/1\"><button class=\"pagination likegoog paginationbtn\">1</button></a>">>;
    false ->
      Pages_First = [<<"<a href=\"/page/1\"><button class=\"pagination likegoog paginationbtn\">&#xab;</button></a><a href=\"/page/">>, erlang:integer_to_binary(Active_Page - 1), <<"\"><button class=\"pagination likegoog paginationbtn\">&#x2190;</button></a>">>],
      P_1 = [<<"<a href=\"/page/">>, erlang:integer_to_binary(Active_Page - 2), <<"\"><button class=\"pagination likegoog paginationbtn\">">>, erlang:integer_to_binary(Active_Page - 2), <<"</button></a><a href=\"/page/">>, erlang:integer_to_binary(Active_Page - 1), <<"\"><button class=\"pagination likegoog paginationbtn\">">>, erlang:integer_to_binary(Active_Page - 1), <<"</button></a>">>]
  end,
  
  Count_To_Last = ((Active_Page + 2) =< Max_Page),
  P_2 = case Count_To_Last of
    true ->
       [<<"<a href=\"/page/">>, erlang:integer_to_binary(Active_Page + 1), <<"\"><button class=\"pagination likegoog paginationbtn\">">>, erlang:integer_to_binary(Active_Page + 1), <<"</button></a><a href=\"/page/">>, erlang:integer_to_binary(Active_Page + 2), <<"\"><button class=\"pagination likegoog paginationbtn\">">>, erlang:integer_to_binary(Active_Page + 2), <<"</button></a>">>];
    false ->
      [<<"<a href=\"/page/">>, erlang:integer_to_binary(Active_Page + 1), <<"\"><button class=\"pagination likegoog paginationbtn\">">>, erlang:integer_to_binary(Active_Page + 1), <<"</button></a>">>]
  end,
  
  [Pages_First, P_1,
  <<"<button class=\"pagination likegoog paginationactive\">">>, erlang:integer_to_binary(Active_Page), <<"</button>">>, P_2,
  <<"<a href=\"/page/">>, erlang:integer_to_binary(Active_Page + 1), <<"\"><button class=\"pagination likegoog paginationbtn\">&#x2192;</button></a><a href=\"/page/">>, erlang:integer_to_binary(Max_Page), <<"\"><button class=\"pagination likegoog paginationbtn\">&#xbb;</button></a>">>];


%generate_pagination(tags, Active_Page, Max_Page, Tag_Id)
generate_pagination(tags, 1, 1, _) ->
  <<"">>;
generate_pagination(tags, 1, Max_Page, Tag_Id) ->
  %first page
  Page_P2 = [ <<"<a href=\"/tag/">>, Tag_Id, <<"/page/2\"><button class=\"pagination likegoog paginationbtn\">2</button></a>">> ],
  
  case Max_Page of
    2 ->
      Pages_Last = [ <<"<a href=\"/tag/">>, Tag_Id, <<"/page/2\"><button class=\"pagination likegoog paginationbtn\">&#x2192;</button></a><a href=\"/tag/">>, Tag_Id, <<"/page/2\"><button class=\"pagination likegoog paginationbtn\">&#xbb;</button></a>">> ];
    _ ->
      Page_P3 = [ <<"<a href=\"/tag/">>, Tag_Id, <<"/page/3\"><button class=\"pagination likegoog paginationbtn\">3</button></a>">> ],
      
      Pages_Last = [Page_P3, <<"<a href=\"/tag/">>, Tag_Id, <<"/page/2\"><button class=\"pagination likegoog paginationbtn\">&#x2192;</button></a><a href=\"/tag/">>, Tag_Id, <<"/page/">>, erlang:integer_to_binary(Max_Page), <<"\"><button class=\"pagination likegoog paginationbtn\">&#xbb;</button></a>">>]
  end,
  
  [<<"<button class=\"pagination likegoog paginationactive\">1</button>">>,
  Page_P2, Pages_Last];
generate_pagination(tags, Max_Page, Max_Page, Tag_Id) ->
  %last page
  case Max_Page of
    2 ->
      Page_P1 = [ <<"<a href=\"/tag/">>, Tag_Id, <<"/page/1\"><button class=\"pagination likegoog paginationbtn\">1</button></a>">> ],
      Page_P2 = <<"">>,
      Pages_Last = <<"">>;
    _ ->
      Page_P1 = [<<"<a href=\"/tag/">>, Tag_Id, <<"/page/">>, erlang:integer_to_binary(Max_Page - 2), <<"\"><button class=\"pagination likegoog paginationbtn\">">>, erlang:integer_to_binary(Max_Page - 2), <<"</button></a>">>],
      Page_P2 = [<<"<a href=\"/tag/">>, Tag_Id, <<"/page/">>, erlang:integer_to_binary(Max_Page - 1), <<"\"><button class=\"pagination likegoog paginationbtn\">">>, erlang:integer_to_binary(Max_Page - 1), <<"</button></a>">>],
      Pages_Last = <<"">>
  end,
  
  [<<"<a href=\"/tag/">>, Tag_Id, <<"/page/1\"><button class=\"pagination likegoog paginationbtn\">&#xab;</button></a>">>,
  <<"<a href=\"/tag/">>, Tag_Id, <<"/page/">>, erlang:integer_to_binary(Max_Page - 1), <<"\"><button class=\"pagination likegoog paginationbtn\">&#x2190;</button></a>">>,
  Page_P1, Page_P2,
  <<"<button class=\"pagination likegoog paginationactive\">">>, erlang:integer_to_binary(Max_Page), <<"</button>">>,
  Pages_Last];
generate_pagination(tags, Active_Page, Max_Page, Tag_Id) ->
  Count_To_First = (Active_Page =:= 2),
  case Count_To_First of
    true ->
       Pages_First = [<<"<a href=\"/tag/">>, Tag_Id, <<"/page/1\"><button class=\"pagination likegoog paginationbtn\">&#xab;</button></a><a href=\"/tag/">>, Tag_Id, <<"/page/1\"><button class=\"pagination likegoog paginationbtn\">&#x2190;</button></a>">>],
       P_1 = <<"<a href=\"/tag/">>, Tag_Id, <<"/page/1\"><button class=\"pagination likegoog paginationbtn\">1</button></a>">>;
    false ->
      Pages_First = [<<"<a href=\"/tag/">>, Tag_Id, <<"/page/1\"><button class=\"pagination likegoog paginationbtn\">&#xab;</button></a><a href=\"/tag/">>, Tag_Id, <<"/page/">>, erlang:integer_to_binary(Active_Page - 1), <<"\"><button class=\"pagination likegoog paginationbtn\">&#x2190;</button></a>">>],
      P_1 = [<<"<a href=\"/tag/">>, Tag_Id, <<"/page/">>, erlang:integer_to_binary(Active_Page - 2), <<"\"><button class=\"pagination likegoog paginationbtn\">">>, erlang:integer_to_binary(Active_Page - 2), <<"</button></a><a href=\"/tag/">>, Tag_Id, <<"/page/">>, erlang:integer_to_binary(Active_Page - 1), <<"\"><button class=\"pagination likegoog paginationbtn\">">>, erlang:integer_to_binary(Active_Page - 1), <<"</button></a>">>]
  end,
  
  Count_To_Last = ((Active_Page + 2) =< Max_Page),
  P_2 = case Count_To_Last of
    true ->
       [<<"<a href=\"/tag/">>, Tag_Id, <<"/page/">>, erlang:integer_to_binary(Active_Page + 1), <<"\"><button class=\"pagination likegoog paginationbtn\">">>, erlang:integer_to_binary(Active_Page + 1), <<"</button></a><a href=\"/tag/">>, Tag_Id, <<"/page/">>, erlang:integer_to_binary(Active_Page + 2), <<"\"><button class=\"pagination likegoog paginationbtn\">">>, erlang:integer_to_binary(Active_Page + 2), <<"</button></a>">>];
    false ->
      [<<"<a href=\"/tag/">>, Tag_Id, <<"/page/">>, erlang:integer_to_binary(Active_Page + 1), <<"\"><button class=\"pagination likegoog paginationbtn\">">>, erlang:integer_to_binary(Active_Page + 1), <<"</button></a>">>]
  end,
  
  [Pages_First, P_1,
  <<"<button class=\"pagination likegoog paginationactive\">">>, erlang:integer_to_binary(Active_Page), <<"</button>">>, P_2,
  <<"<a href=\"/tag/">>, Tag_Id, <<"/page/">>, erlang:integer_to_binary(Active_Page + 1), <<"\"><button class=\"pagination likegoog paginationbtn\">&#x2192;</button></a><a href=\"/tag/">>, Tag_Id, <<"/page/">>, erlang:integer_to_binary(Max_Page), <<"\"><button class=\"pagination likegoog paginationbtn\">&#xbb;</button></a>">>].





