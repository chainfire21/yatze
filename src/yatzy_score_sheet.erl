-module(yatzy_score_sheet).
-type t() :: map().
-export([
        fill/3,
        new/0,
        get/2,
        upper_total/1,
        bonus/1,
        lower_total/1,
        total/1
    ]).
-spec new() -> t().
-spec fill(yatzy:slot(), yatzy:roll(), t()) -> {'ok', t()}
                                             | 'already_filled'
                                             | 'invalid_slot'.
-spec get(yatzy:slot(), t()) -> {'filled', non_neg_integer()}
                              | 'invalid_slot'
                              | 'empty'.
-spec upper_total(t()) -> non_neg_integer().
-spec bonus(t()) -> 0 | 50.
-spec lower_total(t()) -> non_neg_integer().
-spec total(t()) -> non_neg_integer().

new()->
    maps:new().

fill(Slot, Roll, Sheet)->
    case check_valid(Slot) of
        true ->
        case already_filled(Slot,Sheet) of
            empty ->
                Sheet2 = maps:put(Slot,yatzy_score:calc(Slot,Roll),Sheet),
                {'ok',Sheet2};
            _ ->
                'already_filled'
        end;
        false ->
            'invalid_slot'
    end.

get(Slot,Sheet)->
    case check_valid(Slot) of
        true ->
        case already_filled(Slot,Sheet) of
            empty ->
                'empty';
            _ ->
                {'filled',maps:get(Slot,Sheet)}
        end;
        false ->
            'invalid_slot'
    end.
upper_total(Sheet)->
    List = [ones,twos,threes,fours,fives,sixes],
    lists:sum(maps:values(maps:with(List,Sheet))).

bonus(Sheet)->
    case upper_total(Sheet) of
        X when X>62 ->
            50;
        _ ->
            0
    end.

lower_total(Sheet)->
    List = [chance,large_straight,small_straight,one_pair,two_pairs,three_of_a_kind,four_of_a_kind,yatzy,full_house],
    lists:sum(maps:values(maps:with(List,Sheet))).

total(Sheet)->
    upper_total(Sheet) + lower_total(Sheet).

already_filled(Slot,Sheet)->
    maps:get(Slot,Sheet,empty).

check_valid(Slot)->
    List = [ones,twos,threes,fours,fives,sixes,chance,large_straight,small_straight,one_pair,two_pairs,three_of_a_kind,four_of_a_kind,yatzy,full_house],
    lists:member(Slot,List).