%%%-------------------------------------------------------------------
%% @doc yatzy public API
%% @end
%%%-------------------------------------------------------------------

-module(yatzy_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    yatzy_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
-type slot() :: 'ones'|'twos'|'threes'|'fours'|'fives'|'sixes'|'chance'|'large_straight'|'small_straight'|'one_pair'|'two_pair'|'three_of_a_kind'|'four_of_a_kind'|'yatzy'|'full_house'.

-type slot_type() :: 'upper' | 'lower'.

-type roll() :: [1..6].