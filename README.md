This is my implementation of Lox, following the [Crafting Interpreters](http://craftinginterpreters.com/) book by Bob Nystrom.
Why Ruby? Because I hadn't used it in any recent project of mine and I miss it.
The book doesn't cover a ruby implementation,
but Ruby is simple enough that I should still be able to follow the instructions for writing `jlox`.

Edit:
Couple days in and I discovered [Crystal](https://crystal-lang.org/) which is objectively far superior than ruby,
I might rewrite to crystal later. This means I could write a standard library in C with relative ease, and the type system would be appreciated.

Although I tried to stay close to the `jlox` code, some things just look cooler in Ruby, and I am a sucker for good looking code.
Aside from that I am more into FP than OOP so don't expect too many classes.
The behavior should be relatively the same though.

I did add some extra stuff, like adding a ternary operator.
Making this interpreter is like an exercise to me,
and it wouldn't be challenging if I didn't try to do some stuff on my own.

I wanted to write my first interpreter in a scripting language, because that seemed more fun and less serious.
But it quickly made me realize that I have adapted so much to the typing systems of C and Rust, that I can hardly go without.

Additional stuff (that weren't challenges in the book):
* Both `or`, `and` and `||`, `&&` work
* Ternary operator
* `ruby` keyword to evaluate ruby code with (which is fun because now you can recursively use the same interpreter)
* Escaping with `\` in strings
* `+=` and `-=` operators


Run with `ruby src/main.rb <filename>` or without a filename for the REPL
