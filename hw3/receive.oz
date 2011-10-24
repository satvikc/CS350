local
   fun {Loop S T#E Sout}
      case S of M|S1 then
	 case M
	 of Translate(Pattern1) andthen Translate(Guard1) then E=S1 Translate(Body1 T Sout)
	 ...
	 [] Translate(PatternN) andthen Translate(GuardN) then E=S1 Translate(BodyN T Sout)
	 else
	    E1 in E=M|E1
	    {Loop S1 T#E1 Sout}
	 end
      end
   end T
in
   {Loop Sin T#T Sout}
end
%% If any message M matches any of the patterns i.e Patterni , the corresponding Bodyi is executed ans the value of Sout is Sin#M else Sout = Sin
%% If no message mathces any pattern , Loop blocks waiting for any incoming message to match a pattern.

	    