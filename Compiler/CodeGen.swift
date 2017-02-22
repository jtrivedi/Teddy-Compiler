//
//  CodeGen.swift
//  Compiler
//
//  Created by Janum Trivedi on 2/21/17.
//  Copyright © 2017 Janum Trivedi. All rights reserved.
//

public typealias IR = String

public protocol IREmitable {
    func emit() -> IR
}

public enum Language {
    case cpp
}

public enum Library: String {
    case iostream = "#include <iostream>"
    case stdlib = "#include <stdlib.h>"
}

public struct CodeGenerator {
    
    let abstractSyntaxTree: [ExpressionType]
    
    func emit(to language: Language? = .cpp) throws {
        emitLibraryIncludes(libraries: .iostream, .stdlib)
        emitNamespace()
        abstractSyntaxTree.forEach { print($0.emit()) }
    }
    
    func emitNamespace() {
        let namespace = "using namespace std;"
        print(namespace)
    }
    
    func emitLibraryIncludes(libraries: Library...) {
        libraries.forEach { print($0.rawValue) }
    }
}

extension PrototypeNode: IREmitable {
    public func emit() -> IR {
        let formals = arguments.map { "const " + $0.emit().trimLast() }.joined(separator: ", ")
        return "\(self.returnType.emit()) \(name)(\(formals));"
    }
}

extension FunctionNode: IREmitable {
    public func emit() -> IR {
        let signature = self.prototype.emit().trimLast()
        let body = self.body.map { $0.emit() }.joined(separator: "\n")
        let definition = "\(signature) {\(body)}"
        
        return definition
    }
}

extension ReturnNode: IREmitable {
    public func emit() -> IR {
        return "return \(self.returnExpression.emit());"
    }
}

extension PrintNode: IREmitable {
    public func emit() -> IR {
        return self.printExpressions.map { return "cout << \($0.emit()) << endl;" }.joined(separator: "\n")
    }
}

extension CallNode: IREmitable {
    public func emit() -> IR {
        let arguments = self.arguments.map { $0.emit() }.joined(separator: ", ")
        return "\(self.identifier)(\(arguments))"
    }
}

extension TypeNode: IREmitable {
    public func emit() -> IR {
        return self.name.lowercased()
    }
}

extension VariableNode: IREmitable {
    public func emit() -> IR {
        return "\(type.emit()) \(self.identifier);"
    }
}

extension AssignExpression: IREmitable {
    public func emit() -> IR {
        // let cat: String = "moo";
        // string cat = "moo"
        let variableDeclaration = self.variable.emit()
        let trimmed = variableDeclaration.trimLast()
        return "\(trimmed) = \(self.value.emit());"
    }
}

extension FieldAccessNode: IREmitable {
    public func emit() -> IR {
        return self.identifier
    }
}

extension IntegerNode: IREmitable {
    public func emit() -> IR {
        return String(self.value)
    }
}

extension FloatNode: IREmitable {
    public func emit() -> IR {
        return String(self.value)
    }
}

extension StringNode: IREmitable {
    public func emit() -> IR {
        return self.value
    }
}

extension BinaryOperationNode: IREmitable {
    public func emit() -> IR {
        return "\(self.lhs.emit()) \(self.operation) \(self.rhs.emit())"
    }
}



