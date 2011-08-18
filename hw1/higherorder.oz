declare
fun {Map F Ls} % Map function which maps F to each element of List Ls
   case Ls 
   of nil then nil % If the list is empty, return nil to complete the list
   [] (X|XS) then {F X}|{Map F (XS)} % Apply F on first element , and then call Map on the rest of the list
   end
end
fun {Filter F Ls} % Filter function which filters the elements of List Ls based on the predicate F
   case Ls
   of nil then nil 
   [] (X|XS) then % If it is a list,
      if {F X} then X|{Filter F (XS)} % If F X is true include it in the new list ,
      else {Filter F (XS)} % else exclude X from the list
      end
   end
end
fun {Even N} % Dummy function to check if a number is even or not.
   if N mod 2 == 0 then true 
   else false
   end
end
fun {Add X Y} % Dummy function to add two numbers 
   X+Y
end
fun {FoldL Ls F Z} % Fold function with folds the list Ls from left using function F and initial value Z
   case Ls
   of nil then Z % If the list is empty , just return the initial value Z
   [] (X|XS) then {FoldL (XS) F {F Z X}} % Else , apply FoldL on the rest of the list using F and the new inital value {F Z X}
   end
end
fun {Fold_ Ls F Z} % Fold function which folds the list Ls from right using function F and inital value Z
   case Ls
   of nil then Z % If the list is empty ,  just return the inital value Z
   [] (X|XS) then {F X {Fold_ XS F Z}} % Else , apply F on the first element and the fold of the rest of the list
   end
end
{Browse {Map IntToFloat [1 2 3 4 5]}} % Converts each integer to float
{Browse {Filter Even [1 2 3 4 5]}} % Filters to list of even numbers
{Browse {FoldL [1 2 3 4 5] Add 0}} % Reduces the List to the sum of its elements using Add
{Browse {Fold_ [1 2 3 4 5] Add 0}}
