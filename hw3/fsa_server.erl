-module(fsa_server).
-export([start/0,loop/0,automata/2]).

%% starts the server 
start() -> register(automata_server,spawn(fsa_server,loop,[])).

%% listens and spawns a new process to handle the request whenever a client calls join 
%% So it can  handle requests in parallel
loop()->
    receive
        {From,join} ->
            io:format("join successful~n"),
            spawn(fsa_server,automata,[From,accept]),
            loop();
        _ -> loop()
    end.

%%Finite state automaton with 3 states accept,reject,trap. 
%%Sends the client whether the string received till now is accepted or not
%%So can be used as the stream of data comes
automata(From,State) ->
    io:format("State : ~p~n",[State]),
    From ! {self(),check_accepted(State)},
    receive 
        {From,leave} -> 
            From ! {final,check_accepted(State)};
        {From,Value} ->
            case Value of
                a when State==accept -> automata(From,reject);
                b when State==reject -> automata(From,accept);
                _ -> automata(From,trap)
            end
    end.

%% Helper function to return true or false 
check_accepted(State) ->
    case State of
        accept -> true;
        _ -> false
    end.

