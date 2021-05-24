-module('20171177_1').
-export([main/1, pass/4]).

pass(0, OutFile, N, MID)->
    receive
        TokenValue ->
            io:format(OutFile, "Process ~w received token ~w from process ~w\n", [1, TokenValue, 0]),
            MID ! done
    end;

pass(NumProcs, OutFile, N, MID)->
    receive
        TokenValue ->
            io:format(OutFile, "Process ~w received token ~w from process ~w\n", [(NumProcs + 1) rem N, TokenValue, NumProcs]),
            PID = spawn('20171177_1', pass, [NumProcs - 1, OutFile, N, MID]),
            PID ! TokenValue
    end.

main(Args)->
    {_, InFile} = file:open(lists:nth(1,Args), [read]),
    {_, Binary} = file:read_line(InFile),
    file:close(InFile),
    [NumProcs, TokenValue] = lists:map(fun(X) -> {Int, _} = string:to_integer(X), 
                    Int end,
          string:tokens(string:trim(Binary), " ")),
    {_, OutFile} = file:open(lists:nth(2, Args), [write]),
    register(start, spawn('20171177_1', pass, [NumProcs - 1, OutFile, NumProcs, self()])),
    start ! TokenValue,
    receive
        done ->
            file:close(OutFile)
    end.
