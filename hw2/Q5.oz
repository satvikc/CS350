\insert 'Unify.oz'
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
	 then
            case S
	      of nil
	      then
		 {Interpreter XS#{Dictionary.entries @A}}
	      [] nop|nil
	      then
		 {Interpreter XS#{Dictionary.entries @A}}
	      [] [nop]|nil
	      then
		 {Interpreter XS#{Dictionary.entries @A}}
              [] bind|B|C|nil
              then 
                 {Unify B C Env}
                 {Interpreter XS#{Dictionary.entries @A}} 
	      [] loc|B|C|nil
	      then
		 case B
		 of ident(Variable)
		 then
		    local Env1 in
		    %{Dictionary.put Env Variable "x"}
		       {AdjoinAt Env Variable {AddKeyToSAS} Env1}
		       {Interpreter '#'(C#Env1|XS {Dictionary.entries @A})}
		       end
		    else skip
		    end
	      [] V|Vs
            then
               if Vs==nil
               then
                  {Interpreter '#'(V#Env|XS {Dictionary.entries @A})}
               else
                  {Interpreter '#'(V#Env|Vs#Env|XS {Dictionary.entries @A})}
               end
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
Statement = [loc ident(x) [[loc ident(y) [[loc ident(x) [[bind ident(x) ident(y)] [bind ident(x) literal(35)] [bind ident(y) literal(35)]]] [bind ident(y) literal(35)]]]]]
Environment = env()
%Environment = env(x:{AddKeyToSAS} y:{AddKeyToSAS} z:{AddKeyToSAS})
%{BindRefToKeyInSAS 2 1}
%{BindValueToKeyInSAS 1 literal(35)}
%{BindValueToKeyInSAS 2 literal(35)}
%{Browse Environment}
%X=x
%Y=y
%{Browse {Dictionary.entries @A}}
%{Unify ident(x) ident(y) Environment}
%{Browse {Dictionary.entries @A}}
Input = '#'(['#'(Statement Environment)] nil)
{Interpreter Input}
proc {PrettyPrinter L}
   case L of
      nil then skip
   [] X|XS then
      {Browse X}
      {PrettyPrinter XS}
   end
end
{PrettyPrinter {Reverse @O}}
%{Unify ident(x) ident(y) Environment}
%{Browse {RetrieveFromSAS 1}}
