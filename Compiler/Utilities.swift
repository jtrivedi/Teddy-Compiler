//
//  Utilities.swift
//  Compiler
//
//  Created by Janum Trivedi on 2/16/17.
//  Copyright © 2017 Janum Trivedi. All rights reserved.
//

import Foundation

private var expressions = [String: NSRegularExpression]()

public extension String {
    
    public func match(regex: String) -> String? {
        let expression: NSRegularExpression
        if let exists = expressions[regex] {
            expression = exists
        }
        else {
            expression = try! NSRegularExpression(pattern: "^\(regex)", options: [])
            expressions[regex] = expression
        }
        
        let range = expression.rangeOfFirstMatch(in: self, options: [], range: NSMakeRange(0, utf16.count))
        if range.location != NSNotFound {
            return (self as NSString).substring(with: range)
        }
        
        return nil
    }
    
    public func trimLast() -> String {
        return self.substring(to: self.index(before: self.endIndex))
    }
    
    public func camelCased() -> String {
        let first = String(characters.prefix(1)).lowercased()
        let other = String(characters.dropFirst())
        return first + other
    
    }
    
    public static func returnCommentHeader(text: String, width: Int = 100) -> IR {
        var IR = "/*\n"
        
        IR.append(String(repeating: "-", count: width))
        IR.append("\n")
        
        IR.append(String(repeating: " ", count: width))
        IR.append("\n")
        
        let padding = (width - text.characters.count) / 2
        
        IR.append(String(repeating: " ", count: padding))
        IR.append(text)
    
        IR.append(String(repeating: " ", count: padding))
        IR.append("\n")
        
        IR.append(String(repeating: " ", count: width))
        IR.append("\n")
        
        IR.append(String(repeating: "-", count: width))
        IR.append("\n*/\n")
        
        return IR
    }
    
    public static func printHeader(text: String, width: Int = 100) {
        
        print(String(repeating: "-", count: width));
        print(String(repeating: " ", count: width));
        
        let padding = (width - text.characters.count) / 2
        
        print(String(repeating: " ", count: padding), terminator: "")
        print(text, terminator: "")
        print(String(repeating: " ", count: padding))
        
        print(String(repeating: " ", count: width));
        print(String(repeating: "-", count: width));
        
        print()
    }
    
}
