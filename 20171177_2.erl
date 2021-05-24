-module('20171177_2').
-export([main/1, reeeeelaxx/5]).

inputEdges(0, InFile) ->
    done;

inputEdges(N, InFile) ->
    Edges = inputEdges(N-1, InFile),
    {_, Binary} = file:read_line(InFile),
    [U, V, W] = lists:map(fun(X) -> {Int, _} = string:to_integer(X), 
                    Int end,
          string:tokens(string:trim(Binary), " ")),
    if 
        Edges == done ->
            [[U, V, W], [V, U, W]];
        true ->
            lists:merge([[U, V, W], [V, U, W]], Edges)
    end.

reeeeelaxx(Len, Edges, Dist, OutFile) ->
    [U, V, W] = lists:nth(Len, Edges),
    Distu = lists:nth(U, Dist),
    Distv = lists:nth(V, Dist),
    {L1, L2} = lists:split(V-1, Dist),
    [D | L3] = L2,
    NewDist = lists:append([L1, [min(Distv, Distu + W)], L3]),
    if
        Len == 1 ->
            NewDist;
        true ->
        reeeeelaxx(Len-1, Edges, NewDist, OutFile)
    end.

reeeeelaxx(Len, Edges, Dist, OutFile, ParentPID) ->
    [U, V, W] = lists:nth(Len, Edges),
    Distu = lists:nth(U, Dist),
    Distv = lists:nth(V, Dist),
    {L1, L2} = lists:split(V-1, Dist),
    [D | L3] = L2,
    NewDist = lists:append([L1, [min(Distv, Distu + W)], L3]),
    if
        Len == 1 ->
            ParentPID ! NewDist,
            NewDist;
        true ->
        reeeeelaxx(Len-1, Edges, NewDist, OutFile, ParentPID)
    end.

distributeEdges(NumElemsPerProc, Idx, Edges, Dist, OutFile) ->
    {E1, E2} = lists:split(NumElemsPerProc, Edges),
    spawn('20171177_2', reeeeelaxx, [NumElemsPerProc, E1, Dist, OutFile, self()]),
    if
        Idx == 1 ->
            done;
        true ->
            distributeEdges(NumElemsPerProc, Idx-1, E2, Dist, OutFile)
    end.

findMin(A, []) -> [];
findMin([], B) -> [];
findMin([A | RemA], [B | RemB]) ->
    [min(A,B) | findMin(RemA, RemB)].

await(Idx, Dist, OutFile) ->
    receive
        Dist1 ->
            if
                Idx == 1 ->
                    findMin(Dist, Dist1);
                true ->
                    await(Idx-1, findMin(Dist, Dist1), OutFile)
            end
    end.

outer(NumProcs, Idx, NumEdges, Edges, Dist, OutFile) ->
    NumElemsPerProc = NumEdges div NumProcs,
    ElemsThisProc = (NumEdges rem NumProcs) + NumElemsPerProc,
    distributeEdges(NumElemsPerProc, NumProcs-1, Edges, Dist, OutFile),
    if
        ElemsThisProc > 0 ->
            Res = reeeeelaxx(ElemsThisProc, lists:nthtail(NumEdges - ElemsThisProc, Edges), Dist, OutFile);
        true ->
            Res = Dist
    end,
    NewDist = await(NumProcs - 1, Res, OutFile),
    if 
        Idx == 1 ->
            NewDist;
        true ->
            outer(NumProcs, Idx-1, NumEdges, Edges, NewDist, OutFile)
    end.

printOut(Idx, Dist, N, OutFile) ->
    io:format(OutFile, "~p ~p~n", [Idx, lists:nth(Idx, Dist)]),
    if
        Idx == N->
            done;
        true ->
            printOut(Idx+1, Dist, N, OutFile)
    end.

main(Args)->
    {_, InFile} = file:open(lists:nth(1,Args), [read]),
    {_, ProcBin} = file:read_line(InFile),
    [NumProcs] = lists:map(fun(X) -> {Int, _} = string:to_integer(X), 
                    Int end,
          string:tokens(string:trim(ProcBin), " ")),
    {_, NMBin} = file:read_line(InFile),
    [NumVertices, NumEdges] = lists:map(fun(X) -> {Int, _} = string:to_integer(X), 
                    Int end,
          string:tokens(string:trim(NMBin), " ")),
    Edges = inputEdges(NumEdges, InFile),
    {_, SourceBin} = file:read_line(InFile),
    [Source] = lists:map(fun(X) -> {Int, _} = string:to_integer(X), 
                    Int end,
          string:tokens(string:trim(SourceBin), " ")),
    file:close(InFile),

    {_, OutFile} = file:open(lists:nth(2, Args), [write]),
    Dist = lists:append([lists:duplicate(Source-1, 1000000), [0], lists:duplicate(NumVertices - Source, 1000000)]),
    Res = outer(NumProcs, NumVertices, 2*NumEdges, Edges, Dist, OutFile),
    printOut(1, Res, NumVertices, OutFile).
