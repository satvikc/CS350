declare Store C A
C = {NewCell 0}
{Dictionary.new ?Store}
A = {NewCell Store}
fun {AddKeyToSAS}
   {Dictionary.put @A (@C+1) unbound}
   C:=@C+1 
   @C
end
%{Dictionary.put @A 1 "checking"}
%{Browse {AddKeyToSAS}}
%{Browse {AddKeyToSAS}}
%{Browse {AddKeyToSAS}}
%{Browse {AddKeyToSAS}}
%{Dictionary.put @A 1 test}
%{Browse {Dictionary.entries @A}}
%{Browse {Dictionary.member @A 2}}
proc {BindValueToKeyInSAS Key Val}
   if {Dictionary.member @A Key} then
      if {Dictionary.get @A Key}==unbound
      then
         {Dictionary.put @A Key Val}
         %{BindAll equivalence
      else
         {Raise alreadyAssigned(Key Val {Dictionary.get @A Key})}
      end
   else
      {Raise keyDoesNotExist(Key)}
   end
end
fun {GetToRoot Key}
   local Value in
      Value = {Dictionary.get @A Key}
      case Value of
         unbound then Key
      [] equivalence(A) then {GetToRoot A}
      else
         nil
      end
   end
end
proc {BindRefToKeyInSAS Key RefKey}
   if {Dictionary.get @A Key}==unbound
   then {Dictionary.put @A Key equivalence({GetToRoot RefKey})}
   else
      {Raise canNotBound(Key RefKey)}
   end
end
fun {RetrieveFromSAS Key}
   if {Dictionary.member @A Key} then
      local Value in
         Value = {Dictionary.get @A Key}
         case Value of
            unbound then equivalence(Key)
         [] equivalence(X) then {RetrieveFromSAS X}
         []  Y then Y
         else
            nil
         end
      end
   else
      raise missingKey(Key) end
   end
end
%{Test @E}
%{BindValueToKeyInSAS 60 test2}
%{BindRefToKeyInSAS 1 2}
%{BindRefToKeyInSAS 3 1}
%{Browse {Dictionary.entries @A}}
%{Dictionary.put @A 2 5}
%{Browse {RetrieveFromSAS 4}}


   
