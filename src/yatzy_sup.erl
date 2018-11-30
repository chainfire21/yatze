%%%-------------------------------------------------------------------
%% @doc yatzy top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(yatzy_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-export([new_player/1,new_turn/0]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: #{id => Id, start => {M, F, A}}
%% Optional keys are restart, shutdown, type, modules.
%% Before OTP 18 tuples must be used to specify a child. e.g.
%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    {ok, {{one_for_one, 0, 1}, []}}.

%%====================================================================
%% Internal functions
%%====================================================================
new_player(Name)->
    supervisor:start_child(?SERVER,{Name,{yatzy_player_gen_server,start_link,[Name]},permanent,2000,worker,[yatzy_player_gen_server]}).


new_turn()->
    supervisor:start_child(?SERVER,{[],{yatzy_turn_genstatem,start_link,[]},permanent,2000,worker,[yatzy_turn_genstatem]}).