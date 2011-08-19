declare L S Average
fun lazy {RandomNumberGenerator} % Function to generate infinite list of random binary digits 
      {OS.rand} mod 2 | {RandomNumberGenerator}
end
fun {Add X Y} % Dummy function to add two numbers 
   X+Y
end
fun {Main Count}
   thread
      S = {FoldL {List.take L Count} Add 0} % Summing up in the other thread
      Average = {IntToFloat S}/{IntToFloat Count} % average
      
   end
   thread
      L = {RandomNumberGenerator} % Generating the list in a new thread
   end
   {Browse {List.take L Count}} % list of first count number of elements of the list
   Average 
end
{Browse {Main 5}}
   


