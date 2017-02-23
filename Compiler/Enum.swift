//
//  Enum.swift
//  Compiler
//
//  Created by Janum Trivedi on 2/22/17.
//  Copyright © 2017 Janum Trivedi. All rights reserved.
//

//typedef struct _ResultSuccess {
//    char* result;
//    int i;
//} _ResultSuccess;
//
//typedef struct _ResultError {
//    
//} _ResultError;
//
//typedef struct Result {
//    _ResultSuccess* success;
//    _ResultError* error;
//} Result;

private func emitStruct(structName: String, cases: [VariableNode], language: Language, areMembersPointers: Bool) -> IR {
    
    var definition = ""
    definition.append("typedef struct \(structName) {\n")
    
    cases.forEach {
        definition.append("\t")
        
        let memberDeclaration = $0.emit(to: language).components(separatedBy: " ")

        let type = memberDeclaration[0]

        let pointer = areMembersPointers ? "*" : ""
        
        let identifier = memberDeclaration[1]
        
        definition.append("\(type)\(pointer) \(identifier)")
        
        definition.append("\n")
    }
    
    definition.append("}")
    definition.append(" " + structName + ";\n")
    
    return definition
}


extension EnumNode: IREmitable {
    public func emit(to language: Language) -> IR {
        
        var IR = ""

        let caseStructDefinitions = self.cases.map { $0.emit(to: language) }.joined(separator: "\n")
        IR.append(caseStructDefinitions)
        IR.append("\n")
        
        var cases = [VariableNode]()
  
        for enumCase in self.cases {
            let typeNode = TypeNode(name: "_\(self.name + enumCase.caseName)")
            let variableNode = VariableNode(mutability: .immutable, type: typeNode, identifier: enumCase.caseName.lowercased())
            cases.append(variableNode)
        }

        let enumStructDefinition = emitStruct(structName: name, cases: cases, language: language, areMembersPointers: true)
        
        IR.append(enumStructDefinition)
        
        return IR
    }
}

extension EnumCaseNode: IREmitable {
    public func emit(to language: Language) -> IR {
        let structName = "_\(self.enumName + self.caseName)"
        return emitStruct(structName: structName, cases: self.associatedValues, language: language, areMembersPointers: false)
    }
}
