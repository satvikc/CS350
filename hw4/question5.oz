declare Counter C
local
   proc {Init Message Class} %% Method to init 
      init(Value) = Message in (Class.val) :=Value
   end
   proc {Inc Message Class} %% Method to increment 
      inc(Value) = Message in (Class.val) := @(Class.val) + Value
   end
   proc {Browse2 Message Class} %% Not a part of the question , just to print the val 
      {Browse @(Class.val)}
   end
in
   Counter = {NewChunk c(attrs:[val] methods:{NewChunk m(init:Init  browse:Browse2 inc:Inc)})} %% Chunk consisting of methods and attributes
end
fun {MyNew Class Init} %% MyNew function similar to New for classes 
   Fs = {Map Class.attrs fun {$ X} X#{NewCell _} end}
   S={NewChunk {List.toRecord state Fs}}
   proc {Obj M}
      {Class.methods.{Label M} M S}
   end
in
   {Obj Init}
   Obj
end
{Browse Counter} %% To Show that the Counter class is a chunk
C = {MyNew Counter init(0)} %% creates a object with the given init function
{C inc(2)} %% Calls a method of the object 
{C inc(2)} 
{C browse} %% Should print 0+2+2 = 4 
      
