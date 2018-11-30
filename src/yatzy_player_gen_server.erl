-module(yatzy_player_gen_server).
-behavior(gen_server).
-export([start_link/1,
        init/1,
        sheet/1,
        fill/3,
        handle_call/3,
        handle_cast/2,
        stop/0]).

start_link(Name) ->
    gen_server:start_link({local, Name},?MODULE, Name,[]).


stop()->
    gen_server:cast(?MODULE,stop).


%% Callback functions
init(Name) ->
    Sheet = yatzy_score_sheet:new(),
    {ok, Sheet}.


handle_cast(stop,LoopData)->
    {stop, normal, LoopData}.


handle_call({send_sheet},_From,LoopData)->
    {reply, LoopData, LoopData};

handle_call({fill,Slot,Roll},_From, LoopData)->
    case yatzy_score_sheet:fill(Slot,Roll,LoopData) of
        {ok,Reply}->
            {reply,{ok,yatzy_score:calc(Slot,Roll)}, Reply};
        already_filled->
            {reply,{error,already_filled},LoopData};
        invalid_slot->
            {reply,{error,invalid_slot},LoopData}
    end.


%% Customer API functions
sheet(Name)->
    gen_server:call(Name, {send_sheet}).

fill(Name, Slot, Roll)->
    gen_server:call(Name,{fill,Slot,Roll}).