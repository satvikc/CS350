declare
fun {Fib (X|XS) N} % Tail Recursive Fibonacci implementation
   if N<0 then nil
   else if N==0 then [X]
        else if N==1 then (X|XS)
             else {Fib (X+XS.1|X|XS) N-1}
             end
        end
   end
end
fun {Fibonacci N} % Final Function which just takes a number N and calls the tail recursive fibonacci 
   {Reverse {Fib [1 1] N-1}}
end
{Browse {Fibonacci 20}}
