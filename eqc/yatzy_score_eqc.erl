%% -----------------------------------------------------------------------------
%% QuickCheck test for tlv encoder
%% See http://www.quviq.com/products/erlang-quickcheck/
%% -----------------------------------------------------------------------------
-module(yatzy_score_eqc).

-include_lib("eqc/include/eqc.hrl").

-compile(export_all).
%% Generators
gen_dice() ->
    choose(1,6).

gen_dice(N)->
    [gen_dice() || _ <- lists:seq(1,N)].

gen_other(Len, Eyes)->
    ?LET(O,
        (?SUCHTHAT(Other,gen_dice(Len),
        not has_higher_pair(Eyes, lists:sort(Other)))),
        lists:duplicate(5-Len,Eyes)++O).

gen_roll()->
    gen_dice(5).

gen_unique(Len)->
    ?SUCHTHAT(Roll, gen_dice(Len),lists:sort(Roll) == lists:usort(Roll)).
    
has_higher_pair(Eyes, [X,X,_]) when X>Eyes->
    true;
has_higher_pair(Eyes, [_,X,X]) when X>Eyes->
    true;
has_higher_pair(_,_)->
    false.

gen_small_straight()->
    ?SUCHTHAT(Roll,gen_unique(5),is_small_straight(lists:sort(Roll))).

gen_large_straight()->
    ?SUCHTHAT(Roll,gen_unique(5),is_large_straight(lists:sort(Roll))).

gen_two_pair(Eyes)->
    ?LET(Single, gen_dice(),lists:merge(Eyes,Eyes)++[Single]).

gen_three_of_a_kind()->
    ?LET(Three, gen_dice(),[Three,Three,Three,gen_dice(),gen_dice()]).

gen_four_of_a_kind()->
    ?LET(Fours, gen_dice(),[Fours,Fours,Fours,Fours,gen_dice()]).

all_same([X,X,X,X,X])->
    true;
all_same(_)->
    false.

is_small_straight([1,2,3,4,5])->
    true;
is_small_straight(_)->
    false.

is_large_straight([2,3,4,5,6])->
    true;
is_large_straight(_)->
    false.

gen_not_yatzy()->
    ?SUCHTHAT(Roll, gen_roll(), not all_same(Roll)).

%% Property
prop_is_yatzy() ->
    ?FORALL(Eyes, gen_dice(),
        begin
            Roll = lists:duplicate(5,Eyes),
            50 == yatzy_score:calc(yatzy,Roll)
        end
    ).

prop_is_not_yatzy()->
    ?FORALL(Roll, gen_not_yatzy(),
        0 == yatzy_score:calc(yatzy, Roll)).

prop_is_one_pair() ->
    ?FORALL({Eyes,Roll}, ?LET(Eyes, gen_dice(),{Eyes, gen_other(3,Eyes)}),
        begin
            Value = Eyes*2,
            Value == yatzy_score:calc(one_pair, Roll)
        end
    ).

prop_is_not_pair()->
    ?FORALL(Roll, gen_unique(5), 0 == yatzy_score:calc(one_pair,Roll)).

prop_is_two_pairs()->
    ?FORALL({Eyes,Roll}, ?LET(Eyes, gen_unique(2),{Eyes, gen_two_pair(Eyes)}),
        begin
            lists:sum(Eyes)*2 == yatzy_score:calc(two_pairs,Roll)
        end
    ).

prop_three_of_a_kind()->
    ?FORALL(Eyes, gen_three_of_a_kind(),
    lists:nth(1,Eyes)*3 == yatzy_score:calc(three_of_a_kind,Eyes)).

prop_four_of_a_kind()->
    ?FORALL(Eyes, gen_four_of_a_kind(),
    lists:nth(1,Eyes)*4 == yatzy_score:calc(four_of_a_kind,Eyes)).

prop_chance()->
    ?FORALL(Eyes, gen_roll(), lists:sum(Eyes)==yatzy_score:calc(chance, Eyes)).

prop_is_small_straight()->
    ?FORALL(Eyes, gen_small_straight(), 15 == yatzy_score:calc(small_straight,Eyes)).

prop_is_large_straight()->
    ?FORALL(Eyes, gen_large_straight(), 20 == yatzy_score:calc(large_straight,Eyes)).

prop_is_full_house()->
    ?FORALL([One,Two], gen_unique(2),One*3+Two*2 == yatzy_score:calc(full_house,[One,One,One,Two,Two])).

