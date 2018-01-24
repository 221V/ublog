-module(pq).
-compile([export_all, nowarn_export_all]).

%postgresql queries module

% get_all_cities(Mpid)
% update_city_by_id(Mpid, City_Id, City_Name, City_Pop)
% add_city(Mpid, City_Name, City_Pop)
% add_city_return_id(Mpid, City_Name, City_Pop)
% delete_city_by_id(Mpid, City_Id)
% 
% get_user_login(Mpid, Email)
% get_all_posts_count(Mpid)
% get_user_posts_count(Mpid, Uid) % with status=show
% get_tags_orderby_countposts(Mpid) % with status=show
% get_count_tags_in(Mpid, Values)
% get_tag_namenposts_count_by_id(Mpid, Tag_Id)
% update_countposts_tags_in(Mpid, Values)
% get_value_tags_in(Mpid, Values)
% insert_post(Mpid, UId, Title, BB_Preview, Html_Preview, BB_Post, Html_Post, Tags)
% update_post(Mpid, Id, Title, BB_Preview, Html_Preview, BB_Post, Html_Post, Tags)
% get_post_by_id(Mpid, Post_Id)
% get_posts_by_page(Mpid, Limit, Offset)
% get_posts_by_tag_page(Mpid, Tag_Id, Limit, Offset)
% 


%get_all_cities(Mpid) ->
%  pg:select(Mpid, "SELECT id, name, population FROM test ORDER BY id", []).


%update_city_by_id(Mpid, City_Id, City_Name, City_Pop) ->
%  pg:in_up_del(Mpid, "UPDATE test SET name = $1, population = $2 WHERE id = $3", [City_Name, City_Pop, City_Id]).


%add_city(Mpid, City_Name, City_Pop) ->
%  pg:in_up_del(Mpid, "INSERT INTO test (name, population) VALUES ($1, $2)", [City_Name, City_Pop]).


%add_city_return_id(Mpid, City_Name, City_Pop) ->
%  pg:returning(Mpid, "INSERT INTO test (name, population) VALUES ($1, $2) RETURNING id", [City_Name, City_Pop]).


%delete_city_by_id(Mpid, City_Id) ->
%  pg:in_up_del(Mpid, "DELETE FROM test WHERE id = $1", [City_Id]).


get_user_login(Mpid, Email) ->
  pg:select(Mpid, "SELECT id, nickname, password, status FROM u_users WHERE email = $1 LIMIT 1", [Email]).


get_all_posts_count(Mpid) ->
  pg:select(Mpid, "SELECT COUNT(id) FROM u_posts WHERE status = 1", []).


get_user_posts_count(Mpid, Uid) ->
  pg:select(Mpid, "SELECT COUNT(id) FROM u_posts WHERE author_id = $1 AND status = 1", [Uid]).


get_tags_orderby_countposts(Mpid) ->
  pg:select(Mpid, "SELECT id, name, posts_count FROM u_tags WHERE status = 1 ORDER BY posts_count DESC", []).


get_count_tags_in(Mpid, Values) ->
  pg:select(Mpid, "SELECT COUNT(id) FROM u_tags WHERE status = 1 AND id IN (" ++ Values ++ ") ", []).


get_tag_namenposts_count_by_id(Mpid, Tag_Id) ->
  pg:select(Mpid, "SELECT name, posts_count FROM u_tags WHERE status = 1 AND id = $1 LIMIT 1", [Tag_Id]).


update_countposts_tags_in(Mpid, Values) ->
  pg:in_up_del(Mpid, "UPDATE u_tags SET posts_count = posts_count + 1 WHERE status = 1 AND id IN (" ++ Values ++ ") ", []).


get_value_tags_in(Mpid, Values) ->
  pg:select(Mpid, "SELECT id, author_id, name, posts_count, inserted_at FROM u_tags WHERE status = 1 AND id IN (" ++ Values ++ ") ORDER BY posts_count DESC", []).


insert_post(Mpid, UId, Title, BB_Preview, Html_Preview, BB_Post, Html_Post, Tags) ->
  pg:returning(Mpid, "INSERT INTO u_posts (author_id, title, bb_preview_post, html_preview_post, bb_post, html_post, tags) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id", [UId, Title, BB_Preview, Html_Preview, BB_Post, Html_Post, Tags]).


update_post(Mpid, Id, Title, BB_Preview, Html_Preview, BB_Post, Html_Post, Tags) ->
  pg:in_up_del(Mpid, "UPDATE u_posts SET title = $1, bb_preview_post = $2, html_preview_post = $3, bb_post = $4, html_post = $5, tags = $6, updated_at = NOW()  WHERE id = $7 ", [Title, BB_Preview, Html_Preview, BB_Post, Html_Post, Tags, Id]).


get_post_by_id(Mpid, Post_Id) ->
  pg:select(Mpid, "SELECT author_id, title, bb_preview_post, html_preview_post, bb_post, html_post, tags, inserted_at FROM u_posts WHERE id = $1 LIMIT 1", [Post_Id]).


get_posts_by_page(Mpid, Limit, Offset) ->
  pg:select(Mpid, "SELECT id, author_id, title, bb_preview_post, html_preview_post, bb_post, html_post, tags, inserted_at FROM u_posts ORDER BY id DESC LIMIT $1 OFFSET $2", [Limit, Offset]).


get_posts_by_tag_page(Mpid, Tag_Id, Limit, Offset) ->
  pg:select(Mpid, "SELECT id, author_id, title, bb_preview_post, html_preview_post, bb_post, html_post, tags, inserted_at FROM u_posts WHERE tags @> ARRAY[" ++ Tag_Id ++ "] ORDER BY id DESC LIMIT $1 OFFSET $2", [Limit, Offset]).


