declare
fun {Map F Ls}
   case Ls
   of nil then nil
   [] (X|XS) then {F X}|{Map F (XS)}
   end
end

{Browse {Map [1 2 3 4 5] IntToFloat}}

declare
fun {Filter F Ls}
   case Ls
   of nil then nil
   [] (X|XS) then
      {if {F X} then X|{Filter F (XS)}
       else {Filter F (XS)}
       end
       }
   end
end
{Browse {Filter Even L}}
declare
fun {Even N}
   if N mod 2 == 0 then true
   else false
   end
end
fun {By1 N}
   N+1
end
declare
fun {Add X Y}
   X+Y
end
{Browse {FoldL L Add 0}}
{Browse {Map L Even}}

declare
fun {FoldL Ls F Z}
   case Ls
   of nil then Z
   [] (X|XS) then {FoldL (XS) F {F Z X}}
   end
end
{Browse {FoldL L Add 10}}
declare
fun {FoldR Ls F Z}
   case Ls
   of nil then Z
   [] (X|XS) then {F X {FoldR XS F Z}}
   end
end
{Browse {FoldR L Add 10}}
