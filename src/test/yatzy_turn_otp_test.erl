-module(yatzy_turn_otp_test).

-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

roll_valid_test() ->
	{_, A} = yatzy_turn_genstatem:start_link(),
	R = yatzy_turn_genstatem:dice(A),
	K = lists:sublist(R, 1, 4),
	?assertEqual(ok, yatzy_turn_genstatem:roll(A, K)),
	?assertEqual(invalid_keepers, yatzy_turn_genstatem:roll(A, [6,6,6,6,6])),
	?assertEqual(invalid_keepers, yatzy_turn_genstatem:roll(A, [6,6,5,6,6])),
	?assertEqual(invalid_keepers, yatzy_turn_genstatem:roll(A, [1,1,1,1,1])),
	R1 = yatzy_turn_genstatem:dice(A),
	K1 = lists:sublist(R1, 1, 5),
	?assertEqual(ok, yatzy_turn_genstatem:roll(A, K1)),
	?assertEqual(finished, yatzy_turn_genstatem:roll(A, [])),
	?assertEqual(finished, yatzy_turn_genstatem:roll(A, [])),

	{_, B} = yatzy_turn_genstatem:start_link(),
	R2 = yatzy_turn_genstatem:dice(B),
	K2 = lists:sublist(R2, 1, 5),

	
	?assertEqual(ok, yatzy_turn_genstatem:roll(B, K2)),
	?assertEqual(invalid_keepers, yatzy_turn_genstatem:roll(B, [1,2,3,4,5])),
	?assertEqual(invalid_keepers, yatzy_turn_genstatem:roll(B, [2,3,4,5,6])),
	R3 = yatzy_turn_genstatem:dice(B),
	K3 = lists:sublist(R3, 1, 5),

	?assertEqual(ok, yatzy_turn_genstatem:roll(B, K3)),
	?assertEqual(finished, yatzy_turn_genstatem:roll(B, [])),
	?assertEqual(finished, yatzy_turn_genstatem:roll(B, [])),

	yatzy_turn_genstatem:stop(A),
	yatzy_turn_genstatem:stop(B).

evil_roll_test() ->
	[evil_test_gen() || _ <- lists:seq(1, 100)].

evil_test_gen() ->
	{_, A} = yatzy_turn_genstatem:start_link(),
	R = yatzy_turn_genstatem:dice(A),
	K = lists:sublist(R, 1, 4),
	yatzy_turn_genstatem:roll(A, K),
	R1 = yatzy_turn_genstatem:dice(A),
	yatzy_turn_genstatem:stop(A),
	?assertEqual(K--R1, []).