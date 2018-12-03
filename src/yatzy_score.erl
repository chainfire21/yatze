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
    yatzy(to_multiset(Roll,#{}));
calc(full_house,Roll)->
    full_house(to_multiset(Roll,#{}));
calc(three_of_a_kind,Roll)->
    three_of_a_kind(to_multiset(Roll,#{}));
calc(four_of_a_kind,Roll)->
    four_of_a_kind(to_multiset(Roll,#{}));
calc(one_pair,Roll)->
    one_pair(to_multiset(Roll,#{}));
calc(two_pairs,Roll)->
    two_pairs(to_multiset(Roll,#{}));
calc(three_pairs,Roll)->
    three_pairs(to_multiset(Roll,#{}));
calc(five_of_a_kind,Roll)->
    five_of_a_kind(to_multiset(Roll,#{}));
calc(full_straight,Roll)->
    full_straight(Roll);
calc(castle,Roll)->
    castle(to_multiset(Roll,#{}));
calc(tower,Roll)->
    tower(to_multiset(Roll,#{})).


to_multiset([],X)->
    lists:sort(fun({_,B},{_,D})-> B>D end,maps:to_list(X));
to_multiset([H|T],Map)->
    case maps:is_key(H,Map) of
        true->
            M = maps:update_with(H,fun(Num)-> Num+1 end,Map),
            to_multiset(T,M);
        false->
            M = maps:put(H,1,Map),
            to_multiset(T,M)
    end.


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


yatzy([{_,_}])->
    50;
yatzy(_)->
    0.


full_house([{X,Xc},{Y,Yc}|_])when Yc>=2,Xc>2->
    X*3+Y*2;
full_house(_) ->
    0.


three_of_a_kind([{A,B}|_]) when B>=3->
    A*3;
three_of_a_kind(_) ->
    0.


four_of_a_kind([{A,B}|_]) when B>=4->
    A*4;
four_of_a_kind(_) ->
    0.


one_pair([{X,_},{Y,Cy}|_]) when Cy >= 2 ->
    max(X,Y)*2;
one_pair([{X,Cx}|_]) when Cx >=2 ->
    X*2;
one_pair(_) ->
    0.


two_pairs([{X,_},{Y,Cy}|_]) when Cy >=2 ->
    2*X+2*Y;
two_pairs(_)->
    0.


three_pairs([{A,Ac},{B,Bc},{C,Cc}|_]) when Ac>=2,Bc>=2,Cc>=2 ->
    A*2+B*2+C*2;
three_pairs(_)->
    0.


five_of_a_kind([{X,Xc}|_]) when Xc>=5->
    X*5;
five_of_a_kind(_) ->
    0.


full_straight([1,2,3,4,5,6]) ->
    21;
full_straight(_)->
    0.


castle([{X,Xc},{Y,Yc}|_]) when Xc>=3, Yc>=3->
    X*3+Y*3;
castle(_)->
    0.


tower([{X,Xc},{Y,Yc}|_]) when Xc>=4, Yc>=2->
    X*4+Y*2;
tower(_)->
    0.