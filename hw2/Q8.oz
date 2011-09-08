\insert 'Unify.oz'
declare O
O = {NewCell nil}
fun {CheckCompatible R1 R Env}
   local R2 = {RetrieveFromSAS Env.R} in
   case R1 of
      record|RecLabel1|RecContent1|nil
   then
      case R2 of
         record|RecLabel2|RecContent2|nil
      then
         if RecLabel1==RecLabel2 andthen {IsAritySame RecContent1 RecContent2}
         then
            true
         else
            false
         end
      else
         raise notRecord1(R2) end
      end
   else
      raise notRecord2(R1) end
   end
  end
end
proc {FindValue Rec Key Ret}
   case Rec of
      nil then raise keyNotFound(Rec Key) end
   [] X|XS then if X.1 == Key then case X.2.1 of literal(A)
                                   then
                                      local K in
                                         K = {AddKeyToSAS}
                                         {BindValueToKeyInSAS K literal(A) }
                                         Ret = K
                                      end
                                   end
                else Ret = {FindValue XS Key} end
   end
end
proc {AddToEnv Env Env1 P Pold}
   case P of
      record|RecLabel|RecContent|nil
   then
      case Pold of
         record|RecLabel1|RecContent1|nil
      then
         local L in 
            L = {List.map RecContent fun {$ Pair} Pair.2.1#{FindValue RecContent1 Pair.1} end}
            {AdjoinList Env L Env1}
            {Browse Env1}
         end
      end
   else
      {Raise notRecordcannotAdd(P)}
   end
end
proc {AddProcedureToSAS P OldEnv Ident}
   local CE PValue in
      CE = nil
      PValue = P#CE
      %{Unify Ident PValue }
   end
end
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
            [] match|B|C|D|nil
            then
               case B of
                  ident(P)
               then case C of
                       P1#S1
                    then
                       if {CheckCompatible P1 P Env}
                         then local Env1 in
                                 {AddToEnv Env Env1 P1 {RetrieveFromSAS Env.P}}
                                 {Interpreter '#'(S1#Env1|XS {Dictionary.entries @A})}
                              end
                         else
                            {Interpreter '#'(D#Env|XS {Dictionary.entries @A})}
                         end
                    end
               end             
            [] conditional|B|D|nil
            then
               case B of
                  ident(Cond)#T
               then
                  local C in
                     C = {RetrieveFromSAS Env.Cond}
                     if C==literal(true)
                     then {Interpreter '#'(T#Env|XS {Dictionary.entries @A})}
                     else if C==literal(false)
                          then
                             {Interpreter '#'(D#Env|XS {Dictionary.entries @A})}
                          else
                             {Raise notConditional(Cond C)}
                          end
                     end
                  end
               end
              [] bind|B|C|nil
	    then
	       case C
	       of subr|Tail
	       then
		  case B
		  of ident(Variable)
		  then
		     %{Browse Env}
		     %{AddProcedureToSAS C Env B}
		     {Unify B C#nil Env}
		     {Interpreter XS#{Dictionary.entries @A}}
		  else
		     skip
		  end
	       else
		  {Unify B C Env}
		  {Interpreter XS#{Dictionary.entries @A}}
	       end
	      [] localvar|B|C|nil
	      then
		 case B
		 of ident(Variable)
		 then
		    local Env1 in
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
%Statement = [cond [nop] [nop] [nop]]
%Statement1 = [localvar ident(x) [[localvar ident(y) [[localvar ident(x) [[bind ident(x) ident(y)] [bind ident(x) literal(35)] [bind ident(y) literal(35)]]] [bind ident(y) literal(35)]]]]]
Statement1 = [localvar ident(y) [[bind ident(y) literal(100)] [localvar ident(x) [[bind ident(x) [record literal(rec) [[literal(f1) ident(y)] [literal(f2) literal(1002)]]]] [match ident(x) [record literal(rec) [[literal(f1) a] [literal(f2) b]]]#[bind ident(a)  ident(y)] [nop]]]]]]
Statement = [localvar ident(z) [[bind ident(z) literal(true)] [conditional ident(z)#Statement1 [nop]]]]
Statement2 = [localvar ident(max) [localvar ident(a) [localvar ident(b) [localvar ident(c) [[bind ident(max) [subr [ident(x) ident(y) ident(z)] [localvar ident(t) [[bind ident(t) literal(true)][conditional ident(t)#[bind ident(z) ident(x)] [bind ident(z) ident(y)]]]]]] [bind ident(a) literal(3)] [bind ident(b) literal(5)] [nop]]]]]]
Statement3 = [localvar ident(p) [bind ident(p) [subr [ident(x)] [[nop]]]]]
Environment = env()
Input = '#'(['#'(Statement2 Environment)] nil)
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

