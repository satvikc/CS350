declare
fun {El N List} % To Find the element in a list at the given position 
   if N==1 then List.1 else {El N-1 List.2}
   end
end
fun {Change N K} % Recursive procedure to calculate the number of possible change
   local List = [1 5 10 25 50] % Allowed Denominations
   in if K==0 then 0
      else if N<0 then 0
	   else if N==0 then 1
		else {Change N K-1} + {Change N-{El K List} K}
		end
	   end
      end
   end
end
fun {CountChange N} % Final Function  which just takes the amount in paisa and return the number of possible ways to represent 
   {Change N 5}
end
{Browse {CountChange  21}}