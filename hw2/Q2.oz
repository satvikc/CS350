declare O Dict
O = {NewCell nil}
proc {Interpreter Stack}
   O:=Stack|@O
   case Stack
   of F#Store
   then
      case F of X|XS
      then
	 case X of S#Env
	 then case S
	      of nil
	      then
		 {Interpreter XS#nil}
	      [] nop|nil
	      then
		 {Interpreter XS#nil}
	      [] [nop]|nil
	      then
		 {Interpreter XS#nil}
	      [] loc|B|C|nil
	      then
		 case B
		 of ident(Variable)
		 then
		    local Env1 in
		    %{Dictionary.put Env Variable "x"}
		       {AdjoinAt Env Variable "a" Env1}
		       {Interpreter '#'(C#Env1|XS nil)}
		       end
		    else skip
		    end
	      [] V|Vs
	      then
		 {Interpreter '#'([V]#Env|Vs#Env|XS nil)}
		 else skip
	      end
	    else skip
	 end
      else skip
      end
      else skip
   end
end
{Dictionary.new ?Dict}
%Statement = [[nop] [nop] [nop] [nop]]
Statement = [loc ident(x) [loc ident(y) [nop]]]
Environment = env()
{Interpreter '#'(['#'(Statement Environment)] nil)}
proc {PrettyPrinter L}
   case L of
      nil then skip
   [] X|XS then
      {Browse X}
      {PrettyPrinter XS}
   end
end
{PrettyPrinter {Reverse @O}}