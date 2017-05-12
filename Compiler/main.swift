//
// main.swift
// Teddy Compiler
//
// Created by Janum Trivedi on 2/16/17.
//
// Copyright (c) 2015 Janum Trivedi (http://janumtrivedi.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//
// Replace this with your own absolute path to main.teddy (included in this project).
//
let teddyAbsolutePath = "/Users/janum/Teddy/Compiler/main.teddy"

if let rawSource = Loader.read(file: teddyAbsolutePath) {

    let source = Preprocessor.stripComments(from: rawSource)
    
    String.printHeader(text: "Source Input (.teddy)")
    print(source)
    

    String.printHeader(text: "Lexical Analysis")
    let tokens = Lexer.tokenize(input: source)
    tokens.forEach { print($0) }

    
    String.printHeader(text: "Parsing & Semantic Analysis")
    
    let parser = Parser(tokens: tokens)
    let ast = try parser.parse()
    dump(ast)

    
    String.printHeader(text: "Code Generation (Target: C)")
    
    let generator = CodeGenerator(abstractSyntaxTree: ast)
    try generator.emit(to: .c)
    
    print()
}
