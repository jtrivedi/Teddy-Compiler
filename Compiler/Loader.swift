//
//  Loader.swift
//  Compiler
//
//  Created by Janum Trivedi on 2/16/17.
//  Copyright © 2017 Janum Trivedi. All rights reserved.
//

import Foundation

public struct Loader {
    
    static func read(file path: String) -> String? {
        do {
            let source = try String(contentsOfFile: path)
            return source
        }
        catch {
            return nil
        }
    }
    
}
