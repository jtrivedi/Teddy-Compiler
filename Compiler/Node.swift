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

public struct EnumTestNode: ExpressionType {
    let testEnum: VariableNode
    let targetCase: String
}

extension EnumTestNode: IREmitable {
    public func emit(to language: Language) -> IR {
        return ""
    }
}


public typealias ConditionalExpression = ExpressionType

public struct IfStatementNode: ExpressionType {
    let conditional: ConditionalExpression
    let body: [ExpressionType]
}

public struct IfLetNode: ExpressionType {

    let testVariable: VariableNode
    let unwrappedVariables: [VariableNode]
    
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
