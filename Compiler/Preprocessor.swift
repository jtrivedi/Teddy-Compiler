//
//  Preprocessor.swift
//  Compiler
//
//  Created by Janum Trivedi on 2/26/17.
//  Copyright © 2017 Janum Trivedi. All rights reserved.
//

public struct Preprocessor {
    static func stripComments(from source: String) -> String {
        return source.components(separatedBy: "\n").filter {
            $0.match(regex: "\\/\\/.*") == nil
        }.joined(separator: "\n")
    }
}
