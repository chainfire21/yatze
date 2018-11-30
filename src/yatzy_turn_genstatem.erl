-module(yatzy_turn_genstatem).
-behaviour(gen_statem).
-export([start_link/0,dice/1,roll/2,stop/1]).
-export([terminate/3,code_change/4,init/1,callback_mode/0]).
-export([first_roll/3,second_roll/3,third_roll/3]).

start_link()->
    gen_statem:start_link(?MODULE, [],[]).

%Callback Functions
init([])->
    Data = [rand:uniform(6) || _ <- lists:seq(1, 5)],
    {ok, first_roll, Data}.


terminate(_Reason, _State, _Data)->
    void.


code_change(_Vsn, State, Data, _Extra) ->
    {ok,State,Data}.


callback_mode() -> state_functions.

%State callback functions
first_roll({call, From},{keep,Keep},Roll)->
    merge_keep_and_new(From,Keep, Roll, second_roll);
first_roll({call, From},get_roll,Roll)->
    {keep_state,Roll,[{reply,From,Roll}]};
first_roll({call, From},stop,Roll)->
    {stop_and_reply, normal, [{reply, From, Roll}], Roll}.


second_roll({call, From},{keep,Keep},Roll)->
    merge_keep_and_new(From,Keep, Roll, third_roll);
second_roll({call, From},get_roll,Roll)->
    {keep_state,Roll,[{reply,From,Roll}]};
second_roll({call, From},stop,Roll)->
    {stop_and_reply, normal, [{reply, From, Roll}], Roll}.


third_roll({call, From},_,Roll)->
    {keep_state,Roll,[{reply,From,finished}]};
third_roll({call, From},stop,Roll)->
    {stop_and_reply, normal, [{reply, From, Roll}], Roll}.


merge_keep_and_new(From,Keep, Roll, State) ->
    case Keep -- Roll of
        []->
            R = Keep++[rand:uniform(6) || _ <- lists:seq(1, 5 - length(Keep))],
            {next_state,State,R,[{reply,From,ok}]};
        _ ->                        
            {keep_state,Roll,[{reply,From,invalid_keepers}]}
    end.


%Customer API functions
dice(TurnPid)->
    gen_statem:call(TurnPid,get_roll).

roll(TurnPid,Keep)->
    gen_statem:call(TurnPid,{keep, Keep}).

stop(TurnPid)->
    gen_statem:call(TurnPid,stop).