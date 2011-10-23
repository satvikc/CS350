-module(fsa_client).
-export([is_accepted/1,results/1,accept/2]).

%% Explanation given with is_accepted function 
check_accepted(P,[]) -> 
    P ! {self(),leave},
    receive
        {final,Msg} -> 
            c:flush(),
            Msg
    end;
check_accepted(_,[Head|Tail])->
    receive
        {PID,Msg} ->
            io:format("clien message : ~p~n",[Msg]),
            PID ! {self(),Head},
            io:format("check accepted with : ~p~n",[Tail]),
            check_accepted(PID,Tail)
    end.

%%Function as given in the question . return false if the list is empty.
%%Otherwise sends join to the server which spawns a dedicated process for it 
%%and then calls check_accepted which sends each element of the list one by one to the
%%spawned dedicated process and finally sends leave to leave the process

is_accepted([])-> false;
is_accepted(List)-> 
    automata_server ! {self(),join},
    check_accepted(self(),List).

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

