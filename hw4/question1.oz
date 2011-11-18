declare NewWrapper in
proc {NewWrapper ?Wrap ?Unwrap}
   Key = {NewName}
in
   fun {Wrap X}
      fun {$ K} if K==Key then X end end
   end
   fun {Unwrap W}
      {W Key}
   end
end
declare 
local Wrap Unwrap
   {NewWrapper Wrap Unwrap}
   proc {NewPort S P}
      C = {NewCell S}
   in
      P = {Wrap C}
   end
   proc {Send P X} 
      C={Unwrap P}
      Old 
   in
      X|Old = C:= Old
   end
in
   Port = port(newPort:NewPort send:Send)
end
declare S P in
{Port.newPort S P}
{Browse S}
{Port.send P 10}
{Port.send P 20}


      