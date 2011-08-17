declare
fun {Fib (X|XS) N}
   if N<1 then [1]
   else if N==1 then (X|XS)
	else {Fib (X+XS.1|X|XS) N-1}
	end
   end
end
fun {Fibonacci N}
   {Fib [1 1] N-1}
end
{Browse {Fibonacci 10}}