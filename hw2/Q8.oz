\insert 'Unify.oz'
declare O REnv FEnv
O = {NewCell nil}
REnv = {NewCell FEnv}
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
   [] X|XS then if X.1 == Key then case X.2.1 of A
				   then
				      local K in
					 K = {AddKeyToSAS}
					 {BindValueToKeyInSAS K A}
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
	    L = {List.map RecContent fun {$ Pair} case Pair.2.1 of ident(A) then A#{FindValue RecContent1 Pair.1} end end}
	    {AdjoinList Env L Env1}
	    {Browse Env1}
	 end
      end
   else
      {Raise notRecordcannotAdd(P)}
   end
end
fun {RestrictEnvironment Env XS}
     case XS
     of H|T
     then
        if {Value.hasFeature Env H} == true
        then
  	    REnv := {AdjoinAt @REnv H Env.H}
  	    {RestrictEnvironment Env T}
        else
  	 nil
        end
     else
        nil
     end
  end
proc {Subtract XS YS ?ZS}
    ZS = {List.filter XS fun {$ X}  if {List.member X YS} then false else true end end}
end
fun {TupleFlatten XS}
   local IS FS SN in
      IS = {List.flatten XS}
      {List.partition IS fun {$ X} case X of A#B then true else false end end FS SN}
      if {List.length FS} > 0 then
	 {List.append {TupleFlatten {List.map FS fun {$ X} case X of A#B then A|B|nil else nil end end}} SN}
      else
	 SN
      end
   end
end
proc {FindContextEnvironment P OldEnv ?CEnv}
   case P of
      subr|Tail
   then
      local FormalArgs ProcedureBody FlatList FreeList in
	 FormalArgs = {List.map Tail.1 IdentExtracter}
	 ProcedureBody = Tail.2
	 FlatList = {List.map {List.filter {TupleFlatten ProcedureBody} fun {$ X} case X of ident(X) then true else false end end} IdentExtracter}
	 FreeList = {Subtract FlatList FormalArgs}
	 CEnv = {RestrictEnvironment OldEnv FreeList}
      end
   else
      skip
   end
end
proc {ToTuple X Y ?R}
   R = X#Y
end
proc {IdentExtracter X ?R}
   case X
   of ident(V)
   then
      R = V
   else
      skip
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
	    [] apply|ident(F)|ActualArgs
	    then
	       local ProcValue SubRoutine CEnv in
		  ProcValue = {RetrieveFromSAS Env.F}
		  SubRoutine = ProcValue.1
		  CEnv = ProcValue.2
		  case SubRoutine
		  of subr|Tail
		  then
		     local FormalArgs ProcedureBody NewMappings L1 L2 FEnv in
			FormalArgs = Tail.1
			ProcedureBody = Tail.2
			{List.length FormalArgs L1}
			{List.length ActualArgs L2}
			if (L1 == L2)
			then
			   NewMappings = {List.zip {List.map FormalArgs IdentExtracter} {List.map {List.map ActualArgs IdentExtracter} fun {$ A} Env.A end} ToTuple}
			   {AdjoinList CEnv NewMappings FEnv}
			   {Interpreter '#'(['#'(ProcedureBody FEnv)] {Dictionary.entries @A})}
			   {Interpreter XS#{Dictionary.entries @A}}
			else
			   {Raise notSameNumberOfArguments(FormalArgs XS)}
			end
		     end
		  else
		  {Raise notAProcedure(F SubRoutine)}
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
		     local CE in
			%CE = {FindContextEnvironment C Env}
			{Unify B C#Env Env}
			{Interpreter XS#{Dictionary.entries @A}}
		     end
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
Statement1 = [[nop] [nop] [nop]]
Statement2 = [localvar ident(y) [[bind ident(y) literal(100)] [localvar ident(x) [[bind ident(x) [record literal(rec) [[literal(f1) ident(y)] [literal(f2) literal(1002)]]]] [match ident(x) [record literal(rec) [[literal(f1) ident(a)] [literal(f2) ident(b)]]]#[bind ident(a)  ident(y)] [nop]]]]]]
Statement = [localvar ident(z) [[bind ident(z) literal(true)] [conditional ident(z)#Statement1 [nop]]]]
%Statement2 = [localvar ident(max) [localvar ident(a) [localvar ident(b) [localvar ident(c) [[bind ident(max) [subr [ident(x) ident(y) ident(z)] [localvar ident(t) [[bind ident(t) literal(true)][conditional ident(t)#[bind ident(z) ident(x)] [bind ident(z) ident(y)]]]]]] [bind ident(a) literal(3)] [bind ident(b) literal(5)] [nop]]]]]]
Statement4 = [localvar ident(max) [localvar ident(a) [localvar ident(b) [localvar ident(c) [[bind ident(max) [subr [ident(x) ident(y) ident(z)] [localvar ident(t) [[bind ident(t) literal(false)][conditional ident(t)#[bind ident(z) ident(x)] [bind ident(z) ident(y)]]]]]] [bind ident(a) literal(3)] [bind ident(b) literal(5)] [apply ident(max) ident(a) ident(b) ident(c)]]]]]]
Statement5 = [localvar ident(lowerBound) [localvar ident(a) [localvar ident(y) [localvar ident(c) [[bind ident(y) literal(5)] [bind ident(lowerBound) [subr [ident(x)  ident(z)] [localvar ident(t) [[bind ident(t) literal(true)] [conditional ident(t)#[bind ident(z) ident(x)] [bind ident(z) ident(y)]]]]]] [bind ident(a) literal(3)] [apply ident(lowerBound) ident(a) ident(c)]]]]]]
Statement3 = [localvar ident(p) [bind ident(p) [subr [ident(x)] [[nop]]]]]
Environment = env()
Statement6 = [localvar ident(x) [localvar ident(y) [localvar ident(z) [[bind ident(x) [record literal(p) [[literal(f1) ident(y)] [literal(f2) ident(z)]]]] [bind ident(x) [record literal(p) [[literal(f1) literal(2)] [literal(f2) literal(3)]]]]]]]]
Statement7 = [localvar ident(foo)
	      [localvar ident(bar)
	       [localvar ident(quux)
		[[bind ident(bar) [subr [ident(baz)]
		  [bind [record literal(person) [[literal(age) ident(foo)]]] ident(baz)]]]
		 [apply ident(bar) ident(quux)]
		 [bind [record literal(person) [[literal(age) literal(40)]]] ident(quux)]
		 [bind literal(42) ident(foo)]]]]]
Input = '#'(['#'(Statement7  Environment)] nil)
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

