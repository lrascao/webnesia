%% @author Bruno Pedro <>
%% @copyright 2010 tarpipe.com.

%% @doc TEMPLATE.

-module(webnesia_response).
-author('2010 <bpedro@tarpipe.com>').

-export ([encode/1]).
-export ([encode_records/4]).

%--------------------------------------------------------------------
%% @doc
%%
%% @end
%%--------------------------------------------------------------------
encode (Data) ->
    mochijson2:encode(Data).

%--------------------------------------------------------------------
%% @doc
%%
%% @end
%%--------------------------------------------------------------------
encode_records (Records, Table, Limit, Offset) ->
    encode({struct, [{total_rows, mnesia:table_info(Table, size)}, {number_of_rows, length(Records)}, {limit, Limit}, {offset, Offset}, {rows, records_to_structs(mnesia:table_info(Table, attributes), Records)}]}).

%--------------------------------------------------------------------
%% @doc
%%
%% @end
%%--------------------------------------------------------------------
records_to_structs (_, []) ->
    [];

%--------------------------------------------------------------------
%% @doc
%%
%% Convert {Table, [V1, V2, ...]} info {struct, [{K1, V1}]} ??
%%
%% @end
%%--------------------------------------------------------------------
records_to_structs (Attributes, [Record | Tail]) ->
    [_ | Values] = tuple_to_list(Record),
    NewValues =  change_binary(Values,[]), %% if the content is in list it is changed to binary so that id displays correctly at frontend.
    lists:merge(fun(_, _) -> true end, [{struct, lists:zip(Attributes, NewValues)}], records_to_structs(Attributes, Tail)).

change_binary([], Acc)->
	Acc;
change_binary([H|T], Acc) when is_list(H) ->
	change_binary(T,Acc++[list_to_binary(H)]);
change_binary([H|T], Acc) -> change_binary(T,Acc++[H]).
	
