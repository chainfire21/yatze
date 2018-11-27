-module(yatzy_score).
-export([calc/2]).
-spec calc(yatzy:slot(), yatzy:roll()) -> non_neg_integer().

calc(chance, Roll) -> 
    lists:sum(Roll);
calc(ones, Roll) ->
    filter_and_sum(1,Roll);
calc(twos, Roll) ->
    filter_and_sum(2,Roll);
calc(threes, Roll) ->
    filter_and_sum(3,Roll);
calc(fours, Roll) ->
    filter_and_sum(4,Roll);
calc(fives, Roll) ->
    filter_and_sum(5,Roll);
calc(sixes, Roll) ->
    filter_and_sum(6,Roll);
calc(small_straight,Roll) ->
    small_straight(lists:sort(Roll));
calc(large_straight,Roll) ->
    large_straight(lists:sort(Roll));
calc(yatzy,Roll)->
    yatzy(Roll);
calc(full_house,Roll)->
    full_house(lists:sort(Roll));
calc(three_of_a_kind,Roll)->
    three_of_a_kind(lists:sort(Roll));
calc(four_of_a_kind,Roll)->
    four_of_a_kind(lists:sort(Roll));
calc(one_pair,Roll)->
    one_pair(lists:sort(Roll));
calc(two_pairs,Roll)->
    two_pairs(lists:sort(Roll)).

filter_and_sum(Num,Roll)->
    lists:sum(lists:filter(fun(Y) -> Y=:=Num end, Roll)).

small_straight([1,2,3,4,5])->
    15;
small_straight(_)->
    0.

large_straight([2,3,4,5,6])->
    20;
large_straight(_)->
    0.

yatzy([X,X,X,X,X])->
    50;
yatzy(_)->
    0.

full_house([X,X,Y,Y,Y]) when X/=Y ->
    2*X+3*Y;
full_house([X,X,X,Y,Y]) when X/=Y ->
    3*X+2*Y;
full_house(_)->
    0.

three_of_a_kind([_,_,X,X,X])->
    3*X;
three_of_a_kind([_,X,X,X,_])->
    3*X;
three_of_a_kind([X,X,X,_,_])->
    3*X;
three_of_a_kind(_)->
    0.

four_of_a_kind([X,X,X,X,_])->
    4*X;
four_of_a_kind([_,X,X,X,X])->
    4*X;
four_of_a_kind(_)->
    0.

one_pair([_,_,_,X,X])->
    2*X;
one_pair([_,_,X,X,_])->
    2*X;
one_pair([_,X,X,_,_])->
    2*X;
one_pair([X,X,_,_,_])->
    2*X;
one_pair(_)->
    0.

two_pairs([X,X,Y,Y,_]) when X/=Y->
    2*X+2*Y;
two_pairs([X,X,_,Y,Y]) when X/=Y->
    2*X+2*Y;
two_pairs([_,X,X,Y,Y]) when X/=Y->
    2*X+2*Y;
two_pairs(_) ->
    0.
