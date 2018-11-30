-module(yatzy_player_test).
-compile (export_all).
-include_lib("eunit/include/eunit.hrl").

fill_test()->
    yatzy_player:new(person1),
    yatzy_player:new(person2),
    ?assertEqual({ok, {filled,3}},yatzy_player:fill(person1, ones, [1,2,1,3,1])),
    ?assertEqual({ok, {filled,9}},yatzy_player:fill(person1, threes, [3,3,1,3,1])),
    ?assertEqual({ok, {filled,4}},yatzy_player:fill(person1, one_pair, [1,2,1,2,1])),
    ?assertEqual({ok, {filled,3}},yatzy_player:fill(person2, ones, [1,2,1,3,1])),
    ?assertEqual({ok, {filled,12}},yatzy_player:fill(person2, sixes, [6,6,5,3,1])),
    ?assertEqual({ok, {filled,50}},yatzy_player:fill(person2, yatzy, [4,4,4,4,4])).

sheet_test()->
    ?assertEqual(#{ones => 3, threes => 9, one_pair => 4},yatzy_player:sheet(person1)),
    ?assertEqual(#{ones => 3, sixes => 12, yatzy => 50},yatzy_player:sheet(person2)).

stop_test()->
    ?assertEqual({ok,stopped},yatzy_player:stop(person1)),
    ?assertEqual({ok,stopped},yatzy_player:stop(person2)).