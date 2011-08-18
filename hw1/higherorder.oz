declare
fun {Map F Ls}
   case Ls
   of nil then nil
   [] (X|XS) then {F X}|{Map F (XS)}
   end
end
{Browse {Map IntToFloat [1 2 3 4 5]}}
fun {Filter F Ls}
   case Ls
   of nil then nil
   [] (X|XS) then
      if {F X} then X|{Filter F (XS)}
      else {Filter F (XS)}
      end
   end
end
fun {Even N}
   if N mod 2 == 0 then true
   else false
   end
end
{Browse {Filter Even L}}
fun {By1 N}
   N+1
end
fun {Add X Y}
   X+Y
end
fun {FoldL Ls F Z}
   case Ls
   of nil then Z
   [] (X|XS) then {FoldL (XS) F {F Z X}}
   end
end
{Browse {FoldL [1 2 3 4 5] Add 10}} 
fun {FoldR Ls F Z}
   case Ls
   of nil then Z
   [] (X|XS) then {F X {FoldR XS F Z}}
   end
end
{Browse {FoldR [1 2 3 4 5] Add 10}}
