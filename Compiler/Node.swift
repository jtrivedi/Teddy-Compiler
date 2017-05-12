//
// Node.swift
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

import Foundation

public protocol ExpressionType: IREmitable {
    
}

public struct CallNode: ExpressionType {
    let identifier: String
    let arguments: [ExpressionType]
}


public struct FunctionNode: ExpressionType {
    let prototype: PrototypeNode
    let body: [ExpressionType]
}

public struct PrototypeNode: ExpressionType {
    let name: String
    let arguments: [VariableNode]
    let returnType: TypeNode
}

public struct ReturnNode: ExpressionType {
    let returnExpression: ExpressionType
}

public struct PrintNode: ExpressionType {
    let printExpressions: [ExpressionType]
}


enum Mutability {
    case immutable
    case mutable
}

public struct AssignExpression: ExpressionType {
    let variable: VariableNode
    let value: ExpressionType
}

public struct VariableNode: ExpressionType {
    let mutability: Mutability
    let type: TypeNode
    let identifier: String
}


public typealias ConditionalExpression = ExpressionType

public struct IfStatementNode: ExpressionType {
    let conditional: ConditionalExpression
    let body: [ExpressionType]
}


public struct TypeNode: ExpressionType {
    let name: String
    
    static let integerType = TypeNode(name: "Int")
    static let floatType = TypeNode(name: "Float")
    static let stringType = TypeNode(name: "String")
    static let boolType = TypeNode(name: "Bool")
    static let voidType = TypeNode(name: "Void")
}

public struct FieldAccessNode: ExpressionType {
    let identifier: String
}

public struct EnumDefinitionNode: ExpressionType {
    let name: String
    let cases: [EnumCaseDefinitionNode]
}

public struct EnumCaseDefinitionNode: ExpressionType {
    let enumName: String
    let caseName: String
    let associatedValues: [VariableNode]
}

public struct EnumNode: ExpressionType {
    // ... = .Addition(10, 20)
    let enumName: String

    let caseName: String
    let arguments: [ExpressionType]
}

public struct IntegerNode: ExpressionType {
    let value: Int
}

public struct FloatNode: ExpressionType {
    let value: Float
}

public struct StringNode: ExpressionType {
    let value: String
}

public struct BoolNode: ExpressionType {
    let value: Bool
}

public struct BinaryOperationNode: ExpressionType {
    let lhs: ExpressionType
    let operation: String
    let rhs: ExpressionType
}
