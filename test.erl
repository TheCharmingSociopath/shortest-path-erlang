-module('test').
-export([main/0, add2/1, addall/1]).

add2(A) ->
    A+2.

addall(L) ->
    List1 = lists:map(fun add2/1, L),
    io:format("Tower1: ~p ~n", [List1]).

main() ->
    addall([1, 2, 3]).

