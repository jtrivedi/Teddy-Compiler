//
// CodeGen.swift
// Teddy Compiler
//
// Created by Janum Trivedi on 2/21/17.
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

public typealias IR = String

public protocol IREmitable {
    func emit(to language: Language) -> IR
}

public enum Language {
    case c
}

public enum Library: String {
    case iostream = "#include <iostream>"
    case stdlib   = "#include <stdlib.h>"
    case stdio    = "#include <stdio.h>"
}

public struct CodeGenerator {
    
    let abstractSyntaxTree: [ExpressionType]
    
    func emit(to language: Language = .c) throws {
        emitHeader()
        emitLibraryIncludes(libraries: .stdio)

        abstractSyntaxTree.forEach { print($0.emit(to: language)) }
    }
    
    func emitHeader() {
        print(String.returnCommentHeader(text: "Compiled with the Teddy Compiler. Written by Janum Trivedi."))
    }
    
    func emitLibraryIncludes(libraries: Library...) {
        libraries.forEach { print($0.rawValue) }
    }
}

extension PrototypeNode: IREmitable {
    public func emit(to language: Language) -> IR {
        let formals = arguments.map { "const " + $0.emit(to: language).trimLast() }.joined(separator: ", ")
        return "\(self.returnType.emit(to: language)) \(name)(\(formals));"
    }
}

extension FunctionNode: IREmitable {
    public func emit(to language: Language) -> IR {
        let signature = self.prototype.emit(to: language).trimLast()
        let body = self.body.map { "\t" + $0.emit(to: language) }.joined(separator: "\n")
        let definition = "\(signature) {\n\(body)\n}"
        return definition
    }
}

extension ReturnNode: IREmitable {
    public func emit(to language: Language) -> IR {
        return "return \(self.returnExpression.emit(to: language));"
    }
}

extension PrintNode: IREmitable {
    public func emit(to language: Language) -> IR {
        switch language {
        case .c:
            return printExpressions.map { return "printf(\"%s\\n\", \($0.emit(to: language)));" }.joined(separator: "\n")
        }
    }
}

extension CallNode: IREmitable {
    public func emit(to language: Language) -> IR {
        let arguments = self.arguments.map { $0.emit(to: language) }.joined(separator: ", ")
        return "\(self.identifier)(\(arguments))"
    }
}

extension TypeNode: IREmitable {
    public func emit(to language: Language) -> IR {
        switch language {
        case .c:
            switch self.name {
            case "String": return "char*"
            case "Int": return "int"
            case "Float": return "float"
            case "Void": return "void"
            case "Bool": return "bool"
            default: return self.name
            }
        }
    }
}

extension IfStatementNode: IREmitable {
    public func emit(to language: Language) -> IR {
        var IR = ""
        IR.append("if (\(self.conditional.emit(to: language))) {\n")
        IR.append(body.map { "\t" + $0.emit(to: language) }.joined(separator: "\n"))
        IR.append("}")
        return IR
    }
}

extension VariableNode: IREmitable {
    public func emit(to language: Language) -> IR {
        return "\(type.emit(to: language)) \(self.identifier);"
    }
}

extension AssignExpression: IREmitable {
    public func emit(to language: Language) -> IR {
        let variableDeclaration = self.variable.emit(to: language)
        let trimmed = variableDeclaration.trimLast()
        return "\(trimmed) = \(self.value.emit(to: language));"
    }
}

extension FieldAccessNode: IREmitable {
    public func emit(to language: Language) -> IR {
        return self.identifier
    }
}

extension IntegerNode: IREmitable {
    public func emit(to language: Language) -> IR {
        return String(self.value)
    }
}

extension FloatNode: IREmitable {
    public func emit(to language: Language) -> IR {
        return String(self.value)
    }
}

extension StringNode: IREmitable {
    public func emit(to language: Language) -> IR {
        return self.value
    }
}

extension BoolNode: IREmitable {
    public func emit(to language: Language) -> IR {
        return value ? "1" : "0"
    }
}

extension BinaryOperationNode: IREmitable {
    public func emit(to language: Language) -> IR {
        return "\(self.lhs.emit(to: language)) \(self.operation) \(self.rhs.emit(to: language))"
    }
}



