(*
 *  CS164 Fall 94
 *
 *  Programming Assignment 1
 *    Implementation of a simple stack machine.
 *
 *  Skeleton file
 *)

class Main inherits IO {
   convert : A2I <- new A2I;
   stack : List <- new List;
   flag : Bool <- true;

   eval() : Object {
      if (not stack.isNil()) then {
         let top : String <- stack.head() in {
            if top = "+" then {
               pop();
               let a : String, b : String in {
                  a <- pop();
                  b <- pop();
                  push(convert.i2a(convert.a2i(a) + convert.a2i(b)));
               };
            } else if top = "s" then {
               pop();
               let a : String, b : String in {
                  a <- pop();
                  b <- pop();
                  push(a);
                  push(b);
               };
            } else 0 fi fi;
         };
      } else 0 fi
   };

   pop() : String {
      let h : String <- stack.head() in {
         stack <- stack.tail();
         h;
      }
   };

   push(c : String) : Object {
      stack <- stack.cons(c)
   };

   display() : Object {
      let l : List <- stack.copy() in {
         while (not l.isNil()) loop
         {
            out_string(l.head());
            out_string("\n");
            l <- l.tail();
         }
         pool;
      }
   };

   stop(): Bool {
      flag <- false
   };

   main() : Object {
      while flag loop
      {
         out_string("> ");
         let char: String <- in_string() in {
            if char = "e" then eval() else
            if char = "d" then display() else
            if char = "x" then stop() else
            stack <- stack.cons(char)
            fi fi fi;
         };
      }
      pool
   };

};
