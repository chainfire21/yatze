-module(yatzy_sheet_tests).
-compile (export_all).
-include_lib("eunit/include/eunit.hrl").

setup()->
    {'ok',S1} = yatzy_score_sheet:fill(ones, [1,1,1,2,6],yatzy_score_sheet:new()),
    {'ok',S2} = yatzy_score_sheet:fill(twos, [3,2,2,2,2],S1),
    {'ok',S3} = yatzy_score_sheet:fill(threes, [3,3,3,5,2],S2),
    {'ok',S4} = yatzy_score_sheet:fill(fours, [4,4,3,3,2],S3),
    {'ok',S5} = yatzy_score_sheet:fill(fives, [5,6,6,5,3],S4),
    {'ok',S6} = yatzy_score_sheet:fill(sixes, [6,6,6,4,3],S5),
    {'ok',S7} = yatzy_score_sheet:fill(chance, [3,4,1,6,5],S6),
    {'ok',S8} = yatzy_score_sheet:fill(large_straight, [2,3,4,5,6],S7),
    {'ok',S9} = yatzy_score_sheet:fill(small_straight, [1,2,3,4,5],S8),
    {'ok',S10} = yatzy_score_sheet:fill(one_pair, [3,4,4,2,2],S9),
    {'ok',S11} = yatzy_score_sheet:fill(two_pairs, [3,5,5,2,2],S10),
    {'ok',S12} = yatzy_score_sheet:fill(three_of_a_kind, [3,4,4,4,2],S11),
    {'ok',S13} = yatzy_score_sheet:fill(four_of_a_kind, [3,2,2,2,2],S12),
    {'ok',S14} = yatzy_score_sheet:fill(yatzy, [6,6,6,6,6],S13),
    {'ok',S15} = yatzy_score_sheet:fill(full_house, [3,2,3,2,2],S14),
    S15.

get_test()->
    Sheet = setup(),
    ?assertEqual({filled,3},yatzy_score_sheet:get(ones,Sheet)),
    ?assertEqual({filled,8},yatzy_score_sheet:get(twos,Sheet)),
    ?assertEqual({filled,9},yatzy_score_sheet:get(threes,Sheet)),
    ?assertEqual({filled,8},yatzy_score_sheet:get(fours,Sheet)),
    ?assertEqual({filled,10},yatzy_score_sheet:get(fives,Sheet)),
    ?assertEqual({filled,18},yatzy_score_sheet:get(sixes,Sheet)),
    ?assertEqual({filled,19},yatzy_score_sheet:get(chance,Sheet)),
    ?assertEqual({filled,20},yatzy_score_sheet:get(large_straight,Sheet)),
    ?assertEqual({filled,15},yatzy_score_sheet:get(small_straight,Sheet)),
    ?assertEqual({filled,8},yatzy_score_sheet:get(one_pair,Sheet)),
    ?assertEqual({filled,14},yatzy_score_sheet:get(two_pairs,Sheet)),
    ?assertEqual({filled,12},yatzy_score_sheet:get(three_of_a_kind,Sheet)),
    ?assertEqual({filled,8},yatzy_score_sheet:get(four_of_a_kind,Sheet)),
    ?assertEqual({filled,50},yatzy_score_sheet:get(yatzy,Sheet)),
    ?assertEqual({filled,12},yatzy_score_sheet:get(full_house,Sheet)).

upper_test()->
    Sheet = setup(),
    ?assertEqual(56,yatzy_score_sheet:upper_total(Sheet)).

lower_test()->
    Sheet = setup(),
    ?assertEqual(158,yatzy_score_sheet:lower_total(Sheet)).

total_test()->
    Sheet = setup(),
    ?assertEqual(214,yatzy_score_sheet:total(Sheet)).

bonus_test()->
    Sheet = setup(),
    ?assertEqual(0,yatzy_score_sheet:bonus(Sheet)).

