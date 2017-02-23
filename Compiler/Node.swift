//
//  Node.swift
//  Compiler
//
//  Created by Janum Trivedi on 2/21/17.
//  Copyright © 2017 Janum Trivedi. All rights reserved.
//

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

public struct EnumNode: ExpressionType {
    let name: String
    let cases: [EnumCaseNode]
}

public struct EnumCaseNode: ExpressionType {
    let name: String
    let associatedValues: [VariableNode]?
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

public struct BinaryOperationNode: ExpressionType {
    let lhs: ExpressionType
    let operation: String
    let rhs: ExpressionType
}
