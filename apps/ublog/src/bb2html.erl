-module(bb2html).
-compile([export_all, nowarn_export_all]).

% bb codes to html parser module


% bb_parser(BB_Code) % list_string
% getbbfont(Font)
% getbbsize(Size)
% getbbcolor(HEX_Color)
% getbbsmile(Int)
% 
% =================


% we begin parsing here
%bb_parser(BB_Code) % list_string
bb_parser(BB_Code) ->
  BB_Code3 = unicode:characters_to_list(hm:htmlspecialchars( hm:trim_l(BB_Code) ), utf8),
  ?MODULE:bb_scan(BB_Code3, [], text, "").


% we begin scanning BB_Code
%bb_scan(BB_Code, Acc_Tree, Active_BB_Element, Active_Text) % list_string, list, atom, list_string

bb_scan("[code]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{code, open}, {Active_BB_Element, Active_Text} |Acc_Tree], code, "");

bb_scan("[/code]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{code, close}, {text, Active_Text} |Acc_Tree], text, "");

bb_scan("[quote]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code ->
  ?MODULE:bb_scan(T, [{quote, open}, {Active_BB_Element, Active_Text} |Acc_Tree], quote, "");

bb_scan("[/quote]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code ->
  ?MODULE:bb_scan(T, [{quote, close}, {text, Active_Text} |Acc_Tree], text, "");

bb_scan("[b]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{b, open}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[/b]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{b, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[i]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{i, open}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[/i]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{i, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[u]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{u, open}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[/u]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{u, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");


bb_scan("[s]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{s, open}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[/s]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{s, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[sub]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{sub, open}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[/sub]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{sub, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[sup]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{sup, open}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[/sup]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{sup, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[left]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{left, open}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[/left]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{left, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[center]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{center, open}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[/center]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{center, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[right]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{right, open}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[/right]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{right, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[justify]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{justify, open}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[/justify]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{justify, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[table]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{table, open}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[/table]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{table, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[tr]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{tr, open}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[/tr]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{tr, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[td]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{td, open}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[/td]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{td, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[rtl]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{rtl, open}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[/rtl]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{rtl, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[ltr]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{ltr, open}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[/ltr]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{ltr, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[ul]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{ul, open}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[/ul]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{ul, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[ol]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{ol, open}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[/ol]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{ol, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[li]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{li, open}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

bb_scan("[/li]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{li, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");


bb_scan("[font=" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{Active_BB_Element, Active_Text} |Acc_Tree], font, "");
bb_scan("]" ++ T, Acc_Tree, font, Active_Text) ->
  ?MODULE:bb_scan(T, [{font, open, Active_Text} |Acc_Tree], text, "");
bb_scan([H|T], Acc_Tree, font, Active_Text) ->
  ?MODULE:bb_scan(T, Acc_Tree, font, [H] ++ Active_Text);
bb_scan("[/font]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{font, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");


bb_scan("[size=" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{Active_BB_Element, Active_Text} |Acc_Tree], size, "");
bb_scan("]" ++ T, Acc_Tree, size, Active_Text) ->
  ?MODULE:bb_scan(T, [{size, open, Active_Text} |Acc_Tree], text, "");
bb_scan([H|T], Acc_Tree, size, Active_Text) ->
  ?MODULE:bb_scan(T, Acc_Tree, size, [H] ++ Active_Text);
bb_scan("[/size]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{size, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");


bb_scan("[color=" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{Active_BB_Element, Active_Text} |Acc_Tree], color, "");
bb_scan("]" ++ T, Acc_Tree, color, Active_Text) ->
  ?MODULE:bb_scan(T, [{color, open, Active_Text} |Acc_Tree], text, "");
bb_scan([H|T], Acc_Tree, color, Active_Text) ->
  ?MODULE:bb_scan(T, Acc_Tree, color, [H] ++ Active_Text);
bb_scan("[/color]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{color, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");


bb_scan("[img]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{img, open}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");
bb_scan("[img" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{Active_BB_Element, Active_Text} |Acc_Tree], img, "");
bb_scan("]" ++ T, Acc_Tree, img, Active_Text) ->
  ?MODULE:bb_scan(T, [{img, open, Active_Text} |Acc_Tree], img_url, "");
bb_scan([H|T], Acc_Tree, img, Active_Text) ->
  ?MODULE:bb_scan(T, Acc_Tree, img, [H] ++ Active_Text);
bb_scan([H|T], Acc_Tree, img_url, Active_Text) ->
  ?MODULE:bb_scan(T, Acc_Tree, img_url, [H] ++ Active_Text);
bb_scan("[/img]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{img, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");


bb_scan("[email=" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{Active_BB_Element, Active_Text} |Acc_Tree], email, "");
bb_scan("]" ++ T, Acc_Tree, email, Active_Text) ->
  ?MODULE:bb_scan(T, [{email, open, Active_Text} |Acc_Tree], text, "");
bb_scan([H|T], Acc_Tree, email, Active_Text) ->
  ?MODULE:bb_scan(T, Acc_Tree, email, [H] ++ Active_Text);
bb_scan("[/email]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{email, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");


bb_scan("[url=" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{Active_BB_Element, Active_Text} |Acc_Tree], url, "");
bb_scan("]" ++ T, Acc_Tree, url, Active_Text) ->
  ?MODULE:bb_scan(T, [{url, open, Active_Text} |Acc_Tree], text, "");
bb_scan([H|T], Acc_Tree, url, Active_Text) ->
  ?MODULE:bb_scan(T, Acc_Tree, url, [H] ++ Active_Text);
bb_scan("[/url]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{url, close}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");


bb_scan("[youtube]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{Active_BB_Element, Active_Text} |Acc_Tree], youtube_url, "");
bb_scan([H|T], Acc_Tree, youtube_url, Active_Text) ->
  ?MODULE:bb_scan(T, Acc_Tree, youtube_url, [H] ++ Active_Text);
bb_scan("[/youtube]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{Active_BB_Element, Active_Text} |Acc_Tree], text, "");


bb_scan("[hr]" ++ T, Acc_Tree, Active_BB_Element, "") when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{hr} |Acc_Tree], text, "");

bb_scan("[hr]" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  ?MODULE:bb_scan(T, [{hr}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

% whitespace symbols
bb_scan("\r\n" ++ T, Acc_Tree, Active_BB_Element, "") when Active_BB_Element =/= code ->
  ?MODULE:bb_scan(T, [{br} |Acc_Tree], text, "");
  
bb_scan("\r\n" ++ T, Acc_Tree, quote, Active_Text) ->
  ?MODULE:bb_scan(T, [{br}, {text, Active_Text} |Acc_Tree], quote, "");
  
bb_scan("\r\n" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code ->
  ?MODULE:bb_scan(T, [{br}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");
  
bb_scan("\n" ++ T, Acc_Tree, Active_BB_Element, "") when Active_BB_Element =/= code ->
  ?MODULE:bb_scan(T, [{br} |Acc_Tree], text, "");

bb_scan("\n" ++ T, Acc_Tree, quote, Active_Text) ->
  ?MODULE:bb_scan(T, [{br}, {text, Active_Text} |Acc_Tree], quote, "");

bb_scan("\n" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code ->
  ?MODULE:bb_scan(T, [{br}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "");

% smilies

bb_scan(":)" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 1} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 1}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":angel:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 2} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 2}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":angry:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 3} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 3}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan("8-)" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 4} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 4}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":&#39;(" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 5} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 5}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":ermm:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 6} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 6}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":D" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 7} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 7}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan("&lt;3" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 8} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 8}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":(" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 9} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 9}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":O" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 10} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 10}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":P" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 11} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 11}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(";)" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 12} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 12}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":alien:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 13} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 13}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":blink:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 14} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 14}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":blush:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 15} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 15}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":cheerful:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 16} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 16}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":devil:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 17} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 17}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":dizzy:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 18} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 18}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":getlost:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 19} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 19}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":happy:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 20} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 20}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":kissing:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 21} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 21}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":ninja:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 22} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 22}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":pinch:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 23} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 23}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":pouty:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 24} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 24}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":sick:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 25} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 25}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":sideways:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 26} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 26}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":silly:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 27} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 27}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":sleeping:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 28} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 28}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":unsure:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 29} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 29}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":woot:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 30} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 30}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;

bb_scan(":wassat:" ++ T, Acc_Tree, Active_BB_Element, Active_Text) when Active_BB_Element =/= code, Active_BB_Element =/= quote ->
  case Active_Text of
    "" -> ?MODULE:bb_scan(T, [{smile, 31} |Acc_Tree], text, "");
    _ -> ?MODULE:bb_scan(T, [{smile, 31}, {Active_BB_Element, Active_Text} |Acc_Tree], text, "")
  end;


% all other
bb_scan([H|T], Acc_Tree, Active_BB_Element, Active_Text) ->
  %io:format("~tp~n",[T]),
  ?MODULE:bb_scan(T, Acc_Tree, Active_BB_Element, [H] ++ Active_Text);

% happy end :D
bb_scan([], Acc_Tree, Active_BB_Element, Active_Text) ->
  %io:format("~tp~n",["333555"]),
  %io:format("~tp~n",[[{Active_BB_Element, Active_Text}|Acc_Tree]]),
  ?MODULE:bb_convert([{Active_BB_Element, Active_Text} |Acc_Tree], []).


% we end our transform here -- Tree to HTML

% list of tags in tree

% {text, List_String} % here needs reverse list_string
% {code, open}
% {code, close}
% {quote, open}
% {quote, close}
% {b, open}
% {b, close}
% {i, open}
% {i, close}
% {u, open}
% {u, close}
% {s, open}
% {s, close}
% {sub, open}
% {sub, close}
% {sup, open}
% {sup, close}
% {left, open}
% {left, close}
% {center, open}
% {center, close}
% {right, open}
% {right, close}
% {justify, open}
% {justify, close}
% {table, open}
% {table, close}
% {tr, open}
% {tr, close}
% {td, open}
% {td, close}
% {rtl, open}
% {rtl, close}
% {ltr, open}
% {ltr, close}
% {ul, open}
% {ul, close}
% {ol, open}
% {ol, close}
% {li, open}
% {li, close}

% {font, open, List_String} % here needs reverse list_string
% {font, close}
% {size, open, List_String} % here needs reverse list_string
% {size, close}
% {color, open, List_String} % here needs reverse list_string
% {color, close}

% {img, open}
% {img, open, List_String} % here needs reverse list_string % List_String - params (width, height)
% {img_url, List_String} % here needs reverse list_string 
% {img, close}

% {email, open, List_String} % here needs reverse list_string
% {email, close}
% {url, open, List_String} % here needs reverse list_string
% {url, close}

% {youtube_url, List_String} % here needs reverse list_string

% {hr}
% {br}

% {smile, Id}

%bb_convert(Tree, Acc)
bb_convert([{text, ""}|T], Acc) ->
  ?MODULE:bb_convert(T, Acc);

bb_convert([{text, A}|T], Acc) ->
  %io:format("~tp~n",[T]),
  %io:format("~tp~n",[lists:reverse(A)]),
  %io:format("~tp~n",[Acc]),
  
  ?MODULE:bb_convert(T, [lists:reverse(A) |Acc]);

bb_convert([{code, open}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<pre class=\"prettyprint\">">> |Acc]);

bb_convert([{code, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</pre>">> |Acc]);

bb_convert([{quote, open}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<blockquote>">> |Acc]);

bb_convert([{quote, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</blockquote>">> |Acc]);

bb_convert([{b, open}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<b>">> |Acc]);

bb_convert([{b, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</b>">> |Acc]);

bb_convert([{i, open}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<i>">> |Acc]);

bb_convert([{i, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</i>">> |Acc]);

bb_convert([{u, open}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<u>">> |Acc]);

bb_convert([{u, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</u>">> |Acc]);

bb_convert([{s, open}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<s>">> |Acc]);

bb_convert([{s, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</s>">> |Acc]);

bb_convert([{sub, open}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<sub>">> |Acc]);

bb_convert([{sub, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</sub>">> |Acc]);

bb_convert([{sup, open}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<sup>">> |Acc]);

bb_convert([{sup, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</sup>">> |Acc]);

bb_convert([{left, open}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<div class=\"left\">">> |Acc]);

bb_convert([{left, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</div>">> |Acc]);

bb_convert([{center, open}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<div class=\"center\">">> |Acc]);

bb_convert([{center, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</div>">> |Acc]);

bb_convert([{right, open}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<div class=\"right\">">> |Acc]);

bb_convert([{right, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</div>">> |Acc]);

bb_convert([{justify, open}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<div class=\"justify\">">> |Acc]);

bb_convert([{justify, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</div>">> |Acc]);

bb_convert([{table, open}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<table>">> |Acc]);

bb_convert([{table, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</table>">> |Acc]);

bb_convert([{tr, open}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<tr>">> |Acc]);

bb_convert([{tr, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</tr>">> |Acc]);

bb_convert([{td, open}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<td>">> |Acc]);

bb_convert([{td, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</td>">> |Acc]);

bb_convert([{hr}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<hr>">> |Acc]);

bb_convert([{br}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<br>">> |Acc]);

bb_convert([{rtl, open}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<div class=\"rtl\">">> |Acc]);

bb_convert([{rtl, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</div>">> |Acc]);

bb_convert([{ltr, open}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<div class=\"ltr\">">> |Acc]);

bb_convert([{ltr, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</div>">> |Acc]);

bb_convert([{ul, open}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<ul>">> |Acc]);

bb_convert([{ul, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</ul>">> |Acc]);

bb_convert([{ol, open}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<ol>">> |Acc]);

bb_convert([{ol, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</ol>">> |Acc]);

bb_convert([{li, open}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"<li>">> |Acc]);

bb_convert([{li, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</li>">> |Acc]);


% {img, open}
% {img, open, List_String} % here needs reverse list_string % List_String - params (width, height)
% {img_url, List_String} % here needs reverse list_string 
% {img, close}

bb_convert([{img, close}|T], Acc) ->
  [H2,H3|T3] = T,
  %io:format("~tp~n",["we in img"]),
  %io:format("~tp~n",[H3]),
  %io:format("~tp~n",[H2]),
  %io:format("~tp~n",["we in img 2"]),
  case ?MODULE:bb_convert2_img(H2, H3) of
    {ok, Z} ->
      ?MODULE:bb_convert(T3, [ Z |Acc]);
    _ ->
      % err
      ?MODULE:bb_convert(T, Acc)
  end;


bb_convert([{font, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</span>">> |Acc]);

bb_convert([{font, open, Params}|T], Acc) ->
  [_H|Params2] = Params,
  Z = [ <<"<span class=\"bbfont_">>, ?MODULE:getbbfont( lists:reverse(Params2) ), <<"\">">> ],
  ?MODULE:bb_convert(T, [ Z |Acc]);

bb_convert([{size, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</span>">> |Acc]);

bb_convert([{size, open, Params}|T], Acc) ->
  [_H|Params2] = Params,
  Z = [ <<"<span class=\"bbfontsize_">>, ?MODULE:getbbsize( lists:reverse(Params2) ), <<"\">">> ],
  ?MODULE:bb_convert(T, [ Z |Acc]);

bb_convert([{color, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</span>">> |Acc]);

bb_convert([{color, open, Params}|T], Acc) ->
  [_H|Params2] = Params,
  Z = [ <<"<span class=\"bbcolor_">>, ?MODULE:getbbcolor( lists:reverse(Params2) ), <<"\">">> ],
  ?MODULE:bb_convert(T, [ Z |Acc]);

bb_convert([{email, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</a>">> |Acc]);

bb_convert([{color, open, Params}|T], Acc) ->
  [_H|Params2] = Params,
  Z = [ <<"<a href=\"mailto:">>, lists:reverse(Params2), <<"\">">> ],
  ?MODULE:bb_convert(T, [ Z |Acc]);

bb_convert([{url, close}|T], Acc) ->
  ?MODULE:bb_convert(T, [ <<"</a>">> |Acc]);

bb_convert([{url, open, Params}|T], Acc) ->
  Z = [ <<"<a href=\"">>, lists:reverse(Params), <<"\" target=\"_blank\">">> ],
  ?MODULE:bb_convert(T, [ Z |Acc]);

bb_convert([{youtube_url, Params}|T], Acc) ->
  % \[youtube\].+?\[/youtube\]
  
  % [youtube]4_2qNABaZOE[/youtube]
  % <iframe src="https://www.youtube.com/embed/4_2qNABaZOE?wmode=opaque" data-youtube-id="4_2qNABaZOE" allowfullscreen="" width="560" height="315" frameborder="0"></iframe>
  
  % https://www.youtube.com/watch?v=4_2qNABaZOE
  % https://youtu.be/4_2qNABaZOE -> https://www.youtube.com/watch?v=4_2qNABaZOE&feature=youtu.be
  % https://youtu.be/4_2qNABaZOE?t=20s -> https://www.youtube.com/watch?v=4_2qNABaZOE&feature=youtu.be&t=20s
  % <iframe width="560" height="315" src="https://www.youtube.com/embed/4_2qNABaZOE" frameborder="0" gesture="media" allow="encrypted-media" allowfullscreen></iframe>
  % <iframe width="560" height="315" src="https://www.youtube.com/embed/4_2qNABaZOE?start=20" frameborder="0" gesture="media" allow="encrypted-media" allowfullscreen></iframe>

  % todo - fix/add starttime in sceditor and here
  
  % old code
  %re:replace(TokenChars, "\\[youtube\\](.*?)\\[/youtube\\]", "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/\\1\" frameborder=\"0\" gesture=\"media\" allow=\"encrypted-media\" allowfullscreen></iframe>", [global, dotall, caseless]);
  
  [_H|Params2] = Params,
  Z = [ <<"<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/">>, lists:reverse(Params2), <<"\" frameborder=\"0\" gesture=\"media\" allow=\"encrypted-media\" allowfullscreen></iframe>">> ],
  ?MODULE:bb_convert(T, [ Z |Acc]);


bb_convert([{smile, Id}|T], Acc) ->
  ?MODULE:bb_convert(T, [ ?MODULE:getbbsmile(Id) |Acc]);

%bb_convert([{}|T], Acc) ->
%  ?MODULE:bb_convert(T, [ |Acc]);

% happy end :)
bb_convert([], Acc) ->
  Acc.


% helper
bb_convert2_img({text, Url}, {img, open}) ->
  {ok, [ <<"<img src=\"">>, lists:reverse(Url), <<"\">">> ]};
bb_convert2_img({img_url, Url}, {img, open, Params}) ->
  
  % without "[img"
  % [img width=55], [img height=55], [img width=55 height=77], [img=55x77] - width x height , [/img]
  % <img src="http://zzz.ua/img/zzz.jpg" width="55" height="77">
  
  [_H|Params2] = Params,
  Params3 = lists:reverse(Params2),
  Url2 = lists:reverse(Url),
  
  R = ?MODULE:bb_convert3_img(1, re:run(Params3, "^ width=[1-9]{1}[0-9]{0,}$"), Params3, Url2),
  case R of
    {ok, Z} -> 
      R;
    _ ->
      err
  end;
bb_convert2_img(_, _) -> err.

% helper, Type (try is this type) - 1 = [img width=55], 2 = [img height=55], 3 = [img width=55 height=77], 4 = [img=55x77]
%bb_convert3_img(Type, ReRun_Result, Params, Url)
bb_convert3_img(1, nomatch, Params, Url) ->
  % other type, try next
  ?MODULE:bb_convert3_img(2, re:run(Params, "^ height=[1-9]{1}[0-9]{0,}$"), Params, Url);

bb_convert3_img(1, _, Params, Url) ->
  % we found
  [$ ,$w,$i,$d,$t,$h|Width] = Params,
  {ok, [ <<"<img src=\"">>, Url, <<"\" width=\"">>, erlang:list_to_binary(Width), <<"\">">> ]};

bb_convert3_img(2, nomatch, Params, Url) ->
  % other type, try next
  ?MODULE:bb_convert3_img(3, re:run(Params, "^ width=[1-9]{1}[0-9]{0,} height=[1-9]{1}[0-9]{0,}$"), Params, Url);

bb_convert3_img(2, _, Params, Url) ->
  % we found
  [$ ,$h,$e,$i,$g,$h,$t|Height] = Params,
  {ok, [ <<"<img src=\"">>, Url, <<"\" height=\"">>, erlang:list_to_binary(Height), <<"\">">> ]};

bb_convert3_img(3, nomatch, Params, Url) ->
  % other type, try next
  ?MODULE:bb_convert3_img(4, re:run(Params, "^=[1-9]{1}[0-9]{0,}x[1-9]{1}[0-9]{0,}$"), Params, Url);

bb_convert3_img(3, _, Params, Url) ->
  % we found
  [_H, Width0,Height0|_] = string:split(Params, " ",all),
  [$w,$i,$d,$t,$h|Width] = Width0,
  [$h,$e,$i,$g,$h,$t|Height] = Height0,
  {ok, [ <<"<img src=\"">>, Url, <<"\" width=\"">>, erlang:list_to_binary(Width), <<"\" height=\"">>, erlang:list_to_binary(Height), <<"\">">> ]};

bb_convert3_img(4, nomatch, _, _) ->
  % not found
  err;

bb_convert3_img(4, _, Params, Url) ->
  % we found
  [[_H|Width0],Height0|_] = string:split(Params, "x"),
  [$w,$i,$d,$t,$h|Width] = Width0,
  [$h,$e,$i,$g,$h,$t|Height] = Height0,
  {ok, [ <<"<img src=\"">>, Url, <<"\" width=\"">>, erlang:list_to_binary(Width), <<"\" height=\"">>, erlang:list_to_binary(Height), <<"\">">> ]}.


%getbbfont(String)
%getbbfont("Arial") -> "arial";
getbbfont("Arial Black") -> "arialblack";
getbbfont("Comic Sans MS") -> "comicsansms";
getbbfont("Courier New") -> "couriernew";
getbbfont("Georgia") -> "georgia";
getbbfont("Impact") -> "impact";
getbbfont("Sans-serif") -> "sansserif";
getbbfont("Serif") -> "serif";
getbbfont("Times New Roman") -> "timesnewroman";
getbbfont("Trebuchet MS") -> "trebuchetms";
getbbfont("Verdana") -> "verdana";
getbbfont(_) -> "arial".


%getbbsize(String)
getbbsize("1") -> "1";
getbbsize("2") -> "2";
%getbbsize("3") -> "3";
getbbsize("4") -> "4";
getbbsize("5") -> "5";
getbbsize("6") -> "6";
getbbsize("7") -> "7";
getbbsize(_) -> "3".


%getbbcolor(String)
getbbcolor("#000000") -> "1";
getbbcolor("#44B8FF") -> "2";
getbbcolor("#1E92F7") -> "3";
getbbcolor("#0074D9") -> "4";
getbbcolor("#005DC2") -> "5";
getbbcolor("#00369B") -> "6";
getbbcolor("#b3d5f4") -> "7"; % look for todo in mybbcodes.css
getbbcolor("#444444") -> "8";
getbbcolor("#C3FFFF") -> "9";
getbbcolor("#9DF9FF") -> "10";
getbbcolor("#7FDBFF") -> "11";
getbbcolor("#68C4E8") -> "12";
getbbcolor("#419DC1") -> "13";
getbbcolor("#d9f4ff") -> "14";
getbbcolor("#666666") -> "15";
getbbcolor("#72FF84") -> "16";
getbbcolor("#4CEA5E") -> "17";
getbbcolor("#2ECC40") -> "18";
getbbcolor("#17B529") -> "19";
getbbcolor("#008E02") -> "20";
getbbcolor("#c0f0c6") -> "21";
getbbcolor("#888888") -> "22";
getbbcolor("#FFFF44") -> "23";
getbbcolor("#FFFA1E") -> "24";
getbbcolor("#FFDC00") -> "25";
getbbcolor("#E8C500") -> "26";
getbbcolor("#C19E00") -> "27";
getbbcolor("#fff5b3") -> "28";
getbbcolor("#aaaaaa") -> "29";
getbbcolor("#FFC95F") -> "30";
getbbcolor("#FFA339") -> "31";
getbbcolor("#FF851B") -> "32";
getbbcolor("#E86E04") -> "33";
getbbcolor("#C14700") -> "34";
getbbcolor("#ffdbbb") -> "35";
getbbcolor("#cccccc") -> "36";
getbbcolor("#FF857A") -> "37";
getbbcolor("#FF5F54") -> "38";
getbbcolor("#FF4136") -> "39";
getbbcolor("#E82A1F") -> "40";
getbbcolor("#C10300") -> "41";
getbbcolor("#ffc6c3") -> "42";
getbbcolor("#eeeeee") -> "43";
getbbcolor("#FF56FF") -> "44";
getbbcolor("#FF30DC") -> "45";
getbbcolor("#F012BE") -> "46";
getbbcolor("#D900A7") -> "47";
getbbcolor("#B20080") -> "48";
getbbcolor("#fbb8ec") -> "49";
getbbcolor("#ffffff") -> "50";
getbbcolor("#F551FF") -> "51";
getbbcolor("#CF2BE7") -> "52";
getbbcolor("#B10DC9") -> "53";
getbbcolor("#9A00B2") -> "54";
%getbbcolor("#9A00B2") -> "55"; % look for todo in mybbcodes.css
getbbcolor("#e8b6ef") -> "56";
getbbcolor(_) -> "1".


%getbbsmile(Int)
getbbsmile(1) -> <<"<img src=\"/img/emoticons/smile.png\" alt=\":)\" title=\":)\">">>;
getbbsmile(2) -> <<"<img src=\"/img/emoticons/angel.png\" alt=\":angel:\" title=\":angel:\">">>;
getbbsmile(3) -> <<"<img src=\"/img/emoticons/angry.png\" alt=\":angry:\" title=\":angry:\">">>;
getbbsmile(4) -> <<"<img src=\"/img/emoticons/cool.png\" alt=\"8-)\" title=\"8-)\">">>;
getbbsmile(5) -> <<"<img src=\"/img/emoticons/cwy.png\" alt=\":&#39;(\" title=\":&#39;(\">">>;
getbbsmile(6) -> <<"<img src=\"/img/emoticons/ermm.png\" alt=\":ermm:\" title=\":ermm:\">">>;
getbbsmile(7) -> <<"<img src=\"/img/emoticons/grin.png\" alt=\":D\" title=\":D\">">>;
getbbsmile(8) -> <<"<img src=\"/img/emoticons/heart.png\" alt=\"&lt;3\" title=\"&lt;3\">">>;
getbbsmile(9) -> <<"<img src=\"/img/emoticons/sad.png\" alt=\":(\" title=\":(\">">>;
getbbsmile(10) -> <<"<img src=\"/img/emoticons/shocked.png\" alt=\":O\" title=\":O\">">>;
getbbsmile(11) -> <<"<img src=\"/img/emoticons/tongue.png\" alt=\":P\" title=\":P\">">>;
getbbsmile(12) -> <<"<img src=\"/img/emoticons/wink.png\" alt=\";)\" title=\";)\">">>;
getbbsmile(13) -> <<"<img src=\"/img/emoticons/alien.png\" alt=\":alien:\" title=\":alien:\">">>;
getbbsmile(14) -> <<"<img src=\"/img/emoticons/blink.png\" alt=\":blink:\" title=\":blink:\">">>;
getbbsmile(15) -> <<"<img src=\"/img/emoticons/blush.png\" alt=\":blush:\" title=\":blush:\">">>;
getbbsmile(16) -> <<"<img src=\"/img/emoticons/cheerful.png\" alt=\":cheerful:\" title=\":cheerful:\">">>;
getbbsmile(17) -> <<"<img src=\"/img/emoticons/devil.png\" alt=\":devil:\" title=\":devil:\">">>;
getbbsmile(18) -> <<"<img src=\"/img/emoticons/dizzy.png\" alt=\":dizzy:\" title=\":dizzy:\">">>;
getbbsmile(19) -> <<"<img src=\"/img/emoticons/getlost.png\" alt=\":getlost:\" title=\":getlost:\">">>;
getbbsmile(20) -> <<"<img src=\"/img/emoticons/happy.png\" alt=\":happy:\" title=\":happy:\">">>;
getbbsmile(21) -> <<"<img src=\"/img/emoticons/kissing.png\" alt=\":kissing:\" title=\":kissing:\">">>;
getbbsmile(22) -> <<"<img src=\"/img/emoticons/ninja.png\" alt=\":ninja:\" title=\":ninja:\">">>;
getbbsmile(23) -> <<"<img src=\"/img/emoticons/pinch.png\" alt=\":pinch:\" title=\":pinch:\">">>;
getbbsmile(24) -> <<"<img src=\"/img/emoticons/pouty.png\" alt=\":pouty:\" title=\":pouty:\">">>;
getbbsmile(25) -> <<"<img src=\"/img/emoticons/sick.png\" alt=\":sick:\" title=\":sick:\">">>;
getbbsmile(26) -> <<"<img src=\"/img/emoticons/sideways.png\" alt=\":sideways:\" title=\":sideways:\">">>;
getbbsmile(27) -> <<"<img src=\"/img/emoticons/silly.png\" alt=\":silly:\" title=\":silly:\">">>;
getbbsmile(28) -> <<"<img src=\"/img/emoticons/sleeping.png\" alt=\":sleeping:\" title=\":sleeping:\">">>;
getbbsmile(29) -> <<"<img src=\"/img/emoticons/unsure.png\" alt=\":unsure:\" title=\":unsure:\">">>;
getbbsmile(30) -> <<"<img src=\"/img/emoticons/w00t.png\" alt=\":woot:\" title=\":woot:\">">>;
getbbsmile(31) -> <<"<img src=\"/img/emoticons/wassat.png\" alt=\":wassat:\" title=\":wassat:\">">>;
getbbsmile(_) -> <<"<img src=\"/img/emoticons/smile.png\" alt=\":)\" title=\":)\">">>.


