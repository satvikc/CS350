declare O C
O = {NewCell nil}
proc {Interpreter Stack}
   O:=Stack|@O
   case Stack of
      '#'(F Store) then case F of
                       X|XS then case X of
                                    '#'(S Env) the n case S of
                                                      nil then {Interpreter XS#nil}
                                                   [] [nop]|nil then {Interpreter XS#nil }
                                                   [] V|Vs then {Interpreter '#'([V]#Env|Vs#Env|XS nil)}
                                                   else skip
                                                   end
                                 else skip
                                 end
                       else skip
                       end
   else skip
   end
end
Statement = [[nop] [nop] [nop] [nop]]
 {Interpreter '#'(['#'(Statement nil)] nil)}
proc {PrettyPrinter L}
   case L of
      nil then skip
   [] X|XS then
      {Browse X}
      {PrettyPrinter XS}
   end
end
{PrettyPrinter {Reverse @O}}
%X=loc
%{Browse record}
%{Dictionary.new ?C}
%fun {Dict C}
%   {Dictionary.put C 1 "satvik"}
%end
%{Dict C}
%{Browse {Dictionary.get C 1}}
