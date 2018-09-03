class Animal {
   int age;
   String color;

   void hungry() {
       this.color = "literal string";
   }

   void sleeping() {
   }
}

class Dog extends Animal {
   String breed;

   void barking() {
       this.color = "another literal string";
       // comment
   }
}