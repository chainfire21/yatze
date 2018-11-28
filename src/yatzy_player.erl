-module(yatzy_player).
-export([new/1,
        sheet/1,
        fill/3,
        stop/1]).
-spec new(Name::atom()) -> {'ok', pid()}.
-spec fill(Name::atom(), yatzy:slot(), yatzy:roll()) -> {'ok', Score::integer()}
                                                     | {'error', Reason::any()}.
-spec sheet(Name::atom())-> yatzy_sheet:t().
-spec stop(Name::atom())-> {'ok', Stop::any()}.

new(Name)->
    Sheet = yatzy_score_sheet:new(),
    Pid = spawn(fun() -> loop(Sheet) end),
    register(Name, Pid),
    {ok, Pid}.

stop(Name)->
    Name ! {self(),stop},
    receive
        {ok,Stop}->
            {ok, Stop}
    end.

sheet(Name)->
    Name ! {self(),send_sheet},
    receive
        Sheet->
            Sheet
    end.

fill(Name, Slot, Roll)->
    Name ! {self(),fill, Slot, Roll},
    receive
        {ok, Score}->
            {ok, Score};
        {error,Reason}->
            {error,Reason}
    end.

loop(S)->
    receive
        {From, fill, Slot, Roll}->
            S1 = yatzy_score_sheet:fill(Slot,Roll,S),
            case S1 of
                {ok, Sheet}->
                    From ! {ok, yatzy_score_sheet:get(Slot,Sheet)},
                    loop(Sheet);
                already_filled->
                    From ! {error, already_filled},
                    loop(S);
                invalid_slot->
                    From ! {error, invalid_slot},
                    loop(S)
            end;    
        {From, send_sheet}->
            From ! S,
            loop(S);
        {From,stop}->
            From! {ok,stopped};
        _Other->
            {error, uknown_msg},
            loop(S)
    end.