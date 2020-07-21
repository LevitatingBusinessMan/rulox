This is my implementation of Lox, following the "crafting intepreters" book by Bob Nystrom.
Why Ruby? Because I hadn't used it in any recent project of mine and I miss it.
The book doesn't cover a ruby implementation,
but Ruby is simple enough that I should still be able to follow the instructions for writing `jlox`.

Edit:
Couple days in and I discovered [Crystal](https://crystal-lang.org/) which is objectively far superior than ruby,
I might rewrite to crystal later. This means I could write the standard library in C with relative ease.

Although I tried to stay close to the `jlox` code, some things just look cooler in Ruby, and I am a sucker for good looking code.
Aside from that I am more into FP than OOP so don't expect too many classes.
The behavior should be relatively the same though.

I wanted to write my first interpreter in a scripting language, because that seemed more fun and less serious.
But it quickly made me realize that I have adapted so much to the typing systems of C and Rust, that I can hardly go without.
Which makes me wish there was a scripting language with static types that doesn't transpile to JS.
Maybe I could make my own some time.
