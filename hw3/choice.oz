declare S P L Ys SendL in
L = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 .....]
{NewPort S P}
proc {SendL X ?R}
   thread {Send P X} end
end
Ys = {List.map L SendL}
{Browse S.1}
%% oz thread scheduler manages the scheduling of all the threads  and out all the spawned threads , the order in which each thread is executed depends on the scheduler which is non-deterministic in nature. Hence , the order in which the messages are sent to port P also is non-deterministic. Therefore , S.1 chooses from the list of possible statements non-deterministically.
proc{Choose L}
   BoundList TrueList Slist SendList in
   BoundList = {Filter L fun{$ X}
			   case X
			   of A#B then if {IsDet A} then true
				       else false end
			   end
			 end
%% If Length of BoundList is 0 , block
		TrueList = {Filter BoundList fun{$ X}
					case X
					of true#A then true
					[] false#A then false
					else false
					end
					     end
			   }
%% If Length of TrueList is 0 , all are false , raise(missingClause).
		SList = {List.map TrueList fun{$ X}
					      case X
					      of true#S then S
					      else skip
					      end
			}
		SendList = {List.map SList SendL}
		{Browse S.1}
end
%% SList contains the list of statement S1,S2,...SK.					
