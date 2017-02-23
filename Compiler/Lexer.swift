//
//  Lexer.swift
//  Compiler
//
//  Created by Janum Trivedi on 2/3/17.
//  Copyright © 2017 Janum Trivedi. All rights reserved.
//

import Foundation

public typealias Operator = (String, Int)

public enum Token {
    
    // MARK: - Keywords
    
    case T_Function()
    case T_Let()
    case T_Var()
    case T_Integer()
    case T_Float()
    case T_Void()
    case T_String()
    case T_Bool()
    case T_Return()
    case T_Print()
    case T_Enum()
    case T_Case()
    
    // MARK: - Expressions
    
    case T_Identifier(String)
    case T_IntegerConstant(Int)
    case T_FloatConstant(Float)
    case T_BoolConstant(Bool)
    case T_StringConstant(String)
    
    
    // MARK: - Operators
    
    case T_Equal()
    case T_Operator(Operator)
    
    
    // MARK: - Symbols
    
    case T_Arrow()
    case T_Colon()
    case T_Semicolon()
    case T_ParensOpen()
    case T_ParensClose()
    case T_BraceOpen()
    case T_BraceClose()
    case T_Comma()
    case T_Period()
    
    
    // MARK: - Properties
    
    func rawTokenLength() -> Int {
        switch self {
        case .T_Function():                       return 4    // func
        case .T_Let(), .T_Var():                  return 3    // let, var
        case .T_Integer():                        return 3    // int
        case .T_Float():                          return 5    // float
        case .T_Bool():                           return 4    // bool
        case .T_String():                         return 6    // string
        case .T_Void():                           return 4    // void
        case .T_Return():                         return 6    // return
        case .T_Print():                          return 5    // print
        case .T_Enum():                           return 4    // enum
        case .T_Case():                           return 4    // case
            
        case .T_IntegerConstant(let value):       return String(value).characters.count
        case .T_FloatConstant(let value):         return String(value).characters.count
        case .T_BoolConstant(let value):          return value ? 4 : 5 // true || flase
        case .T_StringConstant(let value):        return value.characters.count
            
        case .T_Identifier(let value):            return value.characters.count
            
        case .T_Arrow():                          return 2
        case .T_Colon(), .T_Semicolon():          return 1
        case .T_Equal():                          return 1
        case .T_Operator(_):                      return 1
        case .T_ParensOpen(), .T_ParensClose():   return 1
        case .T_BraceOpen(), .T_BraceClose():     return 1
        case .T_Comma():                          return 1
        case .T_Period():                         return 1
        }
    }
    
    
    // MARK: - Failable init
    
    init?(input: String) {
        
        // MARK: - Whitespace
        
        if let _ = input.match(regex: "[ \t\n]") {
            return nil
        }
            
        
        // MARK: - Keywords
            
        else if let _ = input.match(regex: "func") {
            self = .T_Function()
        }
        else if let _ = input.match(regex: "let") {
            self = .T_Let()
        }
        else if let _ = input.match(regex: "var") {
            self = .T_Var()
        }
        else if let _ = input.match(regex: "Int") {
            self = .T_Integer()
        }
        else if let _ = input.match(regex: "Float") {
            self = .T_Float()
        }
        else if let _ = input.match(regex: "Void") {
            self = .T_Void()
        }
        else if let _ = input.match(regex: "Bool") {
            self = .T_Bool()
        }
        else if let _ = input.match(regex: "String") {
            self = .T_String()
        }
        else if let _ = input.match(regex: "return") {
            self = .T_Return()
        }
        else if let _ = input.match(regex: "print") {
            self = .T_Print()
        }
        else if let _ = input.match(regex: "enum") {
            self = .T_Enum()
        }
        else if let _ = input.match(regex: "case") {
            self = .T_Case()
        }
        
        
        else if let _ = input.match(regex: "->") {
            // Needs precedence over the minus opreator
            self = .T_Arrow()
        }
        
        // MARK: - Arithmetic operators
            
        else if let _ = input.match(regex: "\\=") {
            self = .T_Equal()
        }
        else if let _ = input.match(regex: "\\+") {
            self = .T_Operator(Operator("+", 20))
        }
        else if let _ = input.match(regex: "\\-") {
            self = .T_Operator(Operator("-", 20))
        }
        else if let _ = input.match(regex: "\\*") {
            self = .T_Operator(Operator("*", 40))
        }
        else if let _ = input.match(regex: "\\/") {
            self = .T_Operator(Operator("/", 40))
        }
            
        
        // MARK: - Symbols
        
        else if let _ = input.match(regex: "\\:") {
            self = .T_Colon()
        }
        else if let _ = input.match(regex: "\\;") {
            self = .T_Semicolon()
        }
        else if let _ = input.match(regex: "\\(") {
            self = .T_ParensOpen()
        }
        else if let _ = input.match(regex: "\\)") {
            self = .T_ParensClose()
        }
        else if let _ = input.match(regex: "\\{") {
            self = .T_BraceOpen()
        }
        else if let _ = input.match(regex: "\\}") {
            self = .T_BraceClose()
        }
        else if let _ = input.match(regex: "\\,") {
            self = .T_Comma()
        }
        else if let _ = input.match(regex: "\\.") {
            self = .T_Period()
        }

            
        // MARK: - Constants and identifiers 
            
        else if let match = input.match(regex: "true|false") {
            guard let bool = Bool(match) else { return nil }
            self = .T_BoolConstant(bool)
        }
        else if let match = input.match(regex: "[a-zA-Z][a-zA-Z0-9]*") {
            self = .T_Identifier(match)
        }
        else if let match = input.match(regex: "[0-9]+\\.[0-9]*") {
            guard let float = Float(match) else { return nil }
            self = .T_FloatConstant(float)
        }
        else if let match = input.match(regex: "[0-9]+") {
            guard let integer = Int(match) else { return nil }
            self = .T_IntegerConstant(integer)
        }
        else if let match = input.match(regex: "\".*\"") {
            guard let string = String(match) else { return nil }
            self = .T_StringConstant(string)
        }
        else {
            fatalError("Unable to match a valid token for input \"\(input)\"")
        }

    }
}

public struct Lexer {
    
    public static func tokenize(input: String) -> [Token] {
        
        var tokens = [Token]()
        var content = input
        
        while content.characters.count > 0 {
            if let token = Token(input: content) {
                tokens.append(token)
                
                let stride = token.rawTokenLength()
                let range = content.index(content.startIndex, offsetBy: stride)
                content = content.substring(from: range)
                
                continue
            }
            
            let index = content.index(after: content.startIndex)
            content = content.substring(from: index)
        }
        
        return tokens
    }
}

