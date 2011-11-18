declare X Y Newchunk
proc {Newchunk Ch ?W}
   Key Wrap Unwrap Mychunk View
in
   Key = {NewName}
   fun {Wrap V} %% Wraps into a secure ADT
      fun{$ K} if K==Key then V end end
   end
   fun {Unwrap W} %% UnWraps it
      {W Key}
   end
   Mychunk = {Wrap Ch}
   fun {View V} %% To view a label of a chunk
      {Unwrap Mychunk}.V
   end
   W=rec(view:View)
end
X={Newchunk anyrecord(a:label1 b:label2 c:label3)}
{Browse X} %% To Show that the fields of the record are secured 
{Browse {X.view a}} %% Similar to call X.a for a record . Should display label1
   
      
