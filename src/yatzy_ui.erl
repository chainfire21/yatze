-module(yatzy_ui).
-export([print_sheet/1,
    print/2
    % start_game/1
]).

% start_game([])->
%     io:write().
% start_game([H|T])->
%     .



print_sheet(Sheet)->
    List = [ones,twos,threes,fours,fives,sixes,one_pair,two_pairs,three_of_a_kind,four_of_a_kind,small_straight,large_straight,full_house,chance,yatzy],
    print(List, Sheet).


print([],_)->
    io:fwrite("~14s",[""]);
print([H|T], Sheet) ->
    case maps:get(H,Sheet,blank) of
        blank ->
            io:fwrite("~16w: ~s~n",[H,maps:get(H, Sheet, "")]);
        _ ->
            io:fwrite("~16w: ~p~n",[H,maps:get(H, Sheet)])
    end,
    print(T, Sheet).

