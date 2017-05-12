# The Teddy Programming Language and Compiler

## What is Teddy?
I made up a small language called **Teddy**. Its syntax is very similar to Swift, but with more restrictions so as to make its compiler more approachable.

This project is thus the Teddy **compiler**. That is, it’s a program written in Swift that compiles Teddy source code into C.

It’s currently very half-baked, but I hope to continually refactor it and add more documentation.

## Why?
I built Teddy as an educational project to learn compiler construction. The project itself is small and modular enough that a beginner could understand its design, but not not so trivial that it only compiles simple expressions like `(2 + 2)`.

Teddy is also a dependency-free project. This means each step of the compilation process (lexing, parsing, and code-generation) is implemented in Swift, from scratch.

##  Compilers Overview
I’ll assume you’re interested in learning how compilers (and thus languages) are built, but that you don’t have prior experience. That’s great! Here’s a quick overview of how a compiler works (and thusly how this project is architected).

A **compiler** is simply a program that accepts text of a certain syntax (i.e., our programming language’s syntax) and translates it into another language (i.e., the target language). It’s common for target languages to be assembly (or a similarly lower-level language), but this is not a requirement. Teddy compiles down to C for simplicity’s sake.

There are 5 major “phases” of a compiler:

1. **Lexical Analysis**
Breaking source code up into a series of tokens using regexes.

2. **Parsing**
Using the tokens to built an Abstract Syntax Tree to represent the program.

3. **Semantic Analysis** 
Verifying the program and AST are correct (types match, variables are defined in scope, etc.)

4. **Code Generation**
Translating and “emitting” each node in the AST into the target language.

5. **Optimization**
Optimizing the generated code to increase performance (ex. removing dead code, unrolling loops, strength reduction, etc.)


## Teddy Overview
Teddy implements **3 stages**: lexing, parsing, and code generation. Semantic analysis and optimization can be added later.

Each stage has its own file:

1. **Loader.swift**
Read the text from the Teddy source code file.

2. **Preprocessor.swift**
Strips comments from the source code.

3. **Lexer.swift**
Breaks up the source code into an array of tokens using regular expressions and returns them.

4. **Parser.swift**
Takes the tokens and creates an abstract syntax tree. The Teddy parser is a **top-down recursive descent parser**.

The parser is probably the most intimidating part of the project, but is actually quite simple once you have the intuition of how a RDP works. More on this later.

5. **CodeGen.swift**

Walk through the AST and call the `emit()` function on each node, which prints the node’s equivalent C code.

* **Node.swift**
Defines all possible AST nodes (ex. IntegerNode, AssignmentExpression, PrintNode, etc.).


## Getting Started
Open up the project and navigate to `main.swift` (the “driver” of the compiler).  You may have to replace the path to `teddy.swift` with your own absolute path for now. Then just hit run!

It will read in the Teddy code and execute the three compilation stages, logging its progress along the way.

Then, write your own Teddy code with some simple expressions, and step through the execution of the program. This will help build an intuition of how the compiler works.

Here’s a short list of half-working features in Teddy:

* Function declarations that return simple types (Void, Int, String, Bool, etc.)
```Swift
func main() -> Int {
  return 0;
}
```

* Basic variable declarations
```Swift
// Note the required explicit type declarations and semicolons differ from Swift.
let message: String = "Hello, world!";
```

* Basic arithmetic expressions
```Swift
let x: Int = 2;
let i: Int = (10 + 5) * x;
```

* Function calls
```Swift
func squared(i: Int) -> Int {
  return i * 2;
}

// To fix: this will actually attempt to print 25 as a string (i.e., `printf(%s)` instead of `printf(%i)`), which will fail to compile in C.
print(squared(5));

// This works, though!
print("Hello!")
```

* Some conditionals

You should expect Teddy to _not_ support something rather than to expect it does. After all, it’s only intended to be an educational compiler.

## FAQ
**Why isn’t there more information about the implementation itself?**

I wanted to open-source it first in its current, half-baked form, rather than to never be satisfied with its documentation and never actually ship it.

I wrote a blog post on lexing, and I plan to write accompanying posts about parsing and code generation soon. But don’t let that hold you back from dipping your toes in the water!

I might also write a walkthrough post on how to add a new feature to the language in this project.
 
**X is broken/not implemented.**

Awesome! Please file an issue. Or if you’d like to contribute and fix it yourself, feel free to open up a pull request! I’m also more than happy to help teach you how to fix it yourself, just reach out to me :-)

**CodeGen.swift is super messy.**

I know. I’ll refactor it soon.

**What is Enum.swift?**

I wanted to implement Swift-like associated enums in Teddy. Enum definitions and declarations work, but not anything more yet. Probably best to stay away from that for now.

**Who is Teddy?**

Teddy is my friend’s very handsome cat. Here’s a photo.
![alt tag](https://github.com/jtrivedi/Teddy/raw/master/teddy.jpg)

