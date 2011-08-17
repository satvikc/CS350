declare
fun lazy {Expo N M X}
   N | {Expo ((N*{IntToFloat X})/{IntToFloat M}) (M+1) X}
end
fun lazy {Exponent X}
   {Expo 1.0 1 X}
end
fun {Take N L}
   if N < 1 then nil
   else if L == nil then nil
        else L.1 | {Take (N-1) L.2}
        end
   end
end
fun {Sum A B}
   A+B
end
fun {Approx X N}
   {FoldL {Take N {Exponent X}} Sum 0.0}
end
{Browse {Approx 1 100}}
