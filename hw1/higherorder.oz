declare
fun {Map F Ls}
   case Ls
   of nil then nil
   [] (X|XS) then {F X}|{Map F (XS)}
   end
end
<<<<<<< HEAD
=======
{Browse {Map IntToFloat [1 2 3 4 5]}}
>>>>>>> 8a7812738e8e782e357fc396c8d11190533fcce1
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
<<<<<<< HEAD
fun {Add X Y}
   X+Y
end
fun {FoldLnew Ls F Z}
=======
{Browse {Filter Even L}}
fun {By1 N}
   N+1
end
fun {Add X Y}
   X+Y
end
% {Browse {Map Even [1 2 3 4 5]}}
 
fun {FoldL Ls F Z}
>>>>>>> 8a7812738e8e782e357fc396c8d11190533fcce1
   case Ls
   of nil then Z
   [] (X|XS) then {FoldLnew (XS) F {F Z X}}
   end
end
<<<<<<< HEAD
fun {FoldRnew Ls F Z}
=======
{Browse {FoldL [1 2 3 4 5] Add 10}}
 
fun {FoldR Ls F Z}
>>>>>>> 8a7812738e8e782e357fc396c8d11190533fcce1
   case Ls
   of nil then Z
   [] (X|XS) then {F X {FoldRnew XS F Z}}
   end
end
<<<<<<< HEAD
{Browse {Map IntToFloat [1 4 1 1]}}
{Browse {Filter Even [1 2 4 2 1]}}
{Browse {FoldLnew [1 2 3 4] Add 0}}
{Browse {FoldRnew [1 2 5 1 3] Add 0}}
=======
{Browse {FoldR [1 2 3 4 5] Add 10}}
>>>>>>> 8a7812738e8e782e357fc396c8d11190533fcce1
