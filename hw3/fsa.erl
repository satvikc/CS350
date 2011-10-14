-module(fsa).
-export([is_accepted/1,results/1,accept/2]).

%%Finite state automaton with 3 states accept,reject,trap.
automata(State,[]) -> 
    State;
automata(State,[Head|Tail]) -> 
    case Head of
        a when State==accept -> automata(reject,Tail);
        b when State==reject -> automata(accept,Tail);
        _ -> trap
    end.

%%Function to call finite state automata and return true if accepted and false otherwise
is_accepted([])-> false;
is_accepted(List)->
    accept==automata(accept,List).

%%Helper function which sends the result (to process with pid Pid) of calling is_accepted on the argument X.
accept(Pid,X) ->
    Pid!{self(),is_accepted(X)}.

%%Has two modes of operation depending on whether the first argument is empty list or not
%%Mode 1:If list is not empty then spawns a process for each element on the list and calls is_accepted on them and then calls itself
%%with empty list and the list of Pids of the spawned processes
%%Mode 2:If the first argument is empty list , then it keeps on receiving messages from the Pids in the same order and once message 
%%received it removes that pid from the list and calls itself again with the rest of the pids
result([],[])-> [];
result([],[Pid|Pids])->
    receive
        {Pid,_Msg} -> [_Msg|result([],Pids)]
    end;
result(List,_)->
    Pid=self(),
    Pids = [spawn(fsa,accept,[Pid,X]) || X <- List],
    result([],Pids).

%%Final results function which call result with default arguments
results(List) ->
    result(List,[]).
