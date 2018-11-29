-module(yatzy_turn).
-export([start/0,
        dice/1,
        roll/2,
        stop/1]).

-spec start() -> {'ok', TurnPid::pid()}.

-spec roll(TurnPid::pid(), Keep::[1..6]) -> 'ok' | 'invalid_keepers' | 'finished'.
%% Once the player has selected which dice to keep roll the remaining dice unless they
%%have already been rolled twice.

-spec dice(TurnPid::pid()) -> yatzy:roll().
%% Cust the rolled dice as it stands at this point.

-spec stop(TurnPid::pid()) -> yatzy:roll().
%% Just stop the procees and get out what was rolled.

start()->
    Roll = [rand:uniform(6) || _ <- lists:seq(1, 5)],
    Pid = spawn(fun()-> first_roll(Roll) end),
    {ok, Pid}.

dice(TurnPid)->
    TurnPid ! {self(),dice},
    receive
        Roll->
            Roll
    end.

roll(TurnPid,Keep)->
    TurnPid ! {self(),roll,Keep},
    receive
        {ok, _}->
            ok;
        invalid_keepers->
            invalid_keepers;
        finished->
            finished
    end.

stop(TurnPid)->
    TurnPid ! {self(),stop},
    receive
        {ok,Roll}->
            Roll
    end.

first_roll(Roll)->
    receive
        {From, roll, Keep}->
            case Keep -- Roll of
                []->
                    R = Keep++[rand:uniform(6) || _ <- lists:seq(1, 5 - length(Keep))],
                    From ! {ok,R},
                    second_roll(R);
                _ ->                        
                    From ! invalid_keepers,
                    first_roll(Roll)
            end;
        {From, dice}->
            From ! Roll,
            first_roll(Roll);
        {From, stop}->
            From ! {ok,Roll}        
    end.

second_roll(Roll)->
    receive
        {From, roll, Keep}->
            case Keep -- Roll of
                []->
                    R = Keep++[rand:uniform(6) || _ <- lists:seq(1, 5 - length(Keep))],
                    From ! {ok,R},
                    third_roll(R);
                _ ->                        
                    From ! invalid_keepers,
                    second_roll(Roll)
            end;
        {From, dice}->
            From ! Roll,
            second_roll(Roll);
        {From, stop}->
            From ! {ok,Roll}
    end.

third_roll(Roll)->
    receive
        {From, roll, _}->
            From ! finished,
            third_roll(Roll);
        {From, dice}->
            From ! Roll,
            third_roll(Roll);
        {From, stop}->
            From ! {ok,Roll}
    end.
