declare
fun {Fib (X|XS) N}
   if N<0 then nil
   else if N==0 then [X]
        else if N==1 then (X|XS)
             else {Fib (X+XS.1|X|XS) N-1}
             end
        end
   end
end
fun {Fibonacci N}
   {Reverse {Fib [1 1] N-1}}
end
{Browse {Fibonacci 20}}
