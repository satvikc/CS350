declare
fun lazy {Expo N M X} % Lazy function to give infinite list of exponent
   N | {Expo ((N*{IntToFloat X})/{IntToFloat M}) (M+1) X}
end
fun lazy {Exponent X} % Final lazy function which calls Expo with default arguments
   {Expo 1.0 1 X}
end
fun {Take N L} % Take function implemented to take first N elements from a list L
   if N < 1 then nil
   else if L == nil then nil
        else L.1 | {Take (N-1) L.2}
        end
   end
end
fun {Sum A B} % Sum function implemented to calculate sum of two numbers
   A+B
end
fun {Approx X N} % Function to add up the first N elements of Exponent X
   {FoldL {Take N {Exponent X}} Sum 0.0}
end
{Browse {Take 20 {Exponent 2}}} 
{Browse {Approx 1 100}}
