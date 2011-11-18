declare
class C
   attr pa:A val %% A can only be accessed in C and all its subclasses through this atrribute only
   meth init(X)
      val:=X
   end
   meth A(X) %%meth A cannot be accessed outside C because A cannot be guessed.
      val:=@val+X
   end
   meth browse
      {Browse @val}
   end
   meth foo(M) {self A(M)} end
end
class C1 from C
   meth b(M) A=@pa in {self A(M)} end %%To check the vertical component of inheritance hierarchy
   meth f(O M) {O b(M)} end %%To check the horizontal component of inheritance hierarchy
end
Obj1 = {New C1 init(0)}
Obj2 = {New C1 init(0)}
{Obj1 browse}
{Obj2 browse}
{Obj1 b(1000)} %%Increments val of Obj1 to 1000 using protected method A through b(M)
{Obj1 browse}  %%It should print 1000
{Obj1 f(Obj2 300)} %%Obj1 is able to increment val of Obj2 to 300 (horizontal component)
{Obj2 browse} %%It should print 300
{Obj2 f(Obj1 100)} %%Obj2 is able to increment val of Obj1 to 1100
{Obj1 browse} %%It should print 1100

