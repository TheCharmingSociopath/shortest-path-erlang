-module(fib).
-export([fibo/1, printfibo/1]).
 
%% print fibo arg. and result, with function as parameter
 
printfibo(N) -> 
   Res = fib:fibo(N),
   io:fwrite("~w ~w~n", [N, Res]).
 
fibo(0) -> 0 ; 
fibo(1) -> 1 ; 
fibo(N) when N > 0 -> fibo(N-1) + fibo(N-2) .


