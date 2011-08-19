declare L S
fun lazy {RandomNumberGenerator}
      {OS.rand} mod 2 | {RandomNumberGenerator}
end
fun {Add X Y} % Dummy function to add two numbers 
   X+Y
end
fun {Main Count}
   thread
      L = {RandomNumberGenerator}
   end
   thread
      S = {FoldL {List.take L Count} Add 0}
      {Browse {List.take L Count}}
      %{Browse {IntToFloat S}/{IntToFloat Count}}
   end
end
{Main 5}
   


