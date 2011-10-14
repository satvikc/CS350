-module(discard).
-export([discard/0]).

%%Calls discard/2 with default argument so returns error if the mailbox is empty 
discard() ->
    discard(error,nomessage).

%%Flushes out all the messages ,if the mailbox is empty then return its arguments.
discard(Status,Msg)->
    receive 
        _Msg -> discard(ok,_Msg)
    after 0 ->
        {Status,Msg}
    end.



            

