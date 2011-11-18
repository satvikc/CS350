#include <iostream>
using namespace std;
class Forest;
class TropicalEvergreenForest;
class Animal {
    public:
        virtual void canSurviveIn(Forest&) {
            cout<<"Forest can support Animal"<<endl;
           }
        virtual void canSurviveIn(TropicalEvergreenForest&) {
            cout<<"TropicalEvergreenForest can support Animal"<<endl;
        }
};

class Giraffe : public Animal {
    public:
        virtual void canSurviveIn(Forest&) {
            cout<<"Forest can support Giraffe"<<endl;
           }
        virtual void canSurviveIn(TropicalEvergreenForest&) {
            cout<<"TropicalEvergreenForest can support Giraffe"<<endl;
        }
};

class Forest {
    public:
        virtual void canSupport(Animal& a) {
            a.canSurviveIn(*this);
        }
};
class TropicalEvergreenForest : public Forest {
    public:
        virtual void canSupport(Animal& a) {
            a.canSurviveIn(*this);
        }
};

int main()
{
    Animal *g = new Giraffe();  //declared type of g is Animal, runtime type is Giraffe
    Forest *f = new TropicalEvergreenForest();  //declared type of f is Forest, runtime type is TropicalEverGreenForest
    Animal *h = new Animal();   //declared type of h is Animal, runtime type is Animal
    Forest *i = new Forest();   //declared type of i is Forest, runtime type is Forest
    f->canSupport(*g);
    f->canSupport(*h);
    i->canSupport(*g);
    i->canSupport(*h);
    delete g;
    delete f;
    delete h;
    delete i;
    return 0;
}
