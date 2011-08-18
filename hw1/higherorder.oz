declare
fun {Map F Ls}
   case Ls
   of nil then nil
   [] (X|XS) then {F X}|{Map F (XS)}
   end
end
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
fun {Add X Y}
   X+Y
end
fun {FoldLnew Ls F Z}
   case Ls
   of nil then Z
   [] (X|XS) then {FoldLnew (XS) F {F Z X}}
   end
end
fun {FoldRnew Ls F Z}
   case Ls
   of nil then Z
   [] (X|XS) then {F X {FoldRnew XS F Z}}
   end
end
{Browse {Map IntToFloat [1 4 1 1]}}
{Browse {Filter Even [1 2 4 2 1]}}
{Browse {FoldLnew [1 2 3 4] Add 0}}
{Browse {FoldRnew [1 2 5 1 3] Add 0}}
