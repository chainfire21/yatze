-module(yatzy_ui).
-export([print_sheet/1,
    print/2,
    start_game/0,
    get_players/2
]).

start_game()->
    case io:fread("How many players? ","~d") of
        {ok, [X]}->
            get_players(X,[]);
        {error,Reason}->
            io:fwrite("Error ~p",[Reason])
    end.

get_players(N,List)->
    case N of
        X when X>0 ->
            case io:fread("Player name: ","~a") of
                {ok,Name} ->
                    NewName = lists:nth(1,Name),
                    yatzy_player:new(NewName),
                    NList = List ++ Name,
                    get_players(N-1,NList);
                {error,Reason}->
                    io:fwrite("Error ~p",[Reason])
            end;
        _ ->
            option_state(1,List)
    end.
    
option_state(Turn,PlayerList)->
    case Turn rem length(PlayerList) of
        X ->
            CurrentPlayer = lists:nth(X,PlayerList),
            io:fwrite("Player ~p is up!~n",[CurrentPlayer]),
            {ok,TurnPid} = yatzy_turn:start(),
            io:fwrite("Here are your dice: ~p~n",[yatzy_turn:dice(TurnPid)]),
            case io:fread("Reroll some dice?(y/n)","~a") of
                {ok,[y]} ->
                    io:fread("Enter dice to keep separated by spaces")
                {ok,[n]}->

            end;
    end.


print_sheet(Sheet)->
    List = [ones,twos,threes,fours,fives,sixes,one_pair,two_pairs,three_of_a_kind,four_of_a_kind,small_straight,large_straight,full_house,chance,yatzy],
    print(List, Sheet).


print([],_)->
    io:fwrite("~14s",[""]);
print([H|T], Sheet) ->
    case maps:get(H,Sheet,blank) of
        blank ->
            io:fwrite("~16w: ~s~n",[H,""]);
        X ->
            io:fwrite("~16w: ~p~n",[H,X])
    end,
    print(T, Sheet).

