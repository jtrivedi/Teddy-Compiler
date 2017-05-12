//
// Enum.swift
// Teddy Compiler
//
// Created by Janum Trivedi on 2/22/17.
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

private func emitStruct(structName: String, cases: [VariableNode], language: Language) -> IR {
    var definition = ""
    definition.append("typedef struct \(structName) {\n")
    
    cases.forEach {
        definition.append("\t")
        
        let memberDeclaration = $0.emit(to: language).components(separatedBy: " ")

        let type = memberDeclaration[0]
        
        let identifier = memberDeclaration[1]
        
        definition.append("\(type) \(identifier)")
        
        definition.append("\n")
    }
    
    definition.append("}")
    definition.append(" " + structName + ";\n")
    
    return definition
}


extension EnumDefinitionNode: IREmitable {
    public func emit(to language: Language) -> IR {
        
        var IR = ""

        let caseStructDefinitions = self.cases.map { $0.emit(to: language) }.joined(separator: "\n")
        IR.append(caseStructDefinitions)
        IR.append("\n")
        
        var cases = [VariableNode]()
  
        for enumCase in self.cases {
            let typeNode = TypeNode(name: "_\(self.name + enumCase.caseName)")
            let variableNode = VariableNode(mutability: .immutable, type: typeNode, identifier: enumCase.caseName)
            cases.append(variableNode)
        }

        let enumStructDefinition = emitStruct(structName: name, cases: cases, language: language)
        
        IR.append(enumStructDefinition)
        IR.append("\n")
        
        IR.append(emitEnumCaseInitFunctions(language: language))

        return IR
    }
    
    private func emitEnumCaseInitFunctions(language: Language) -> IR {
        
        var IR = ""
        
        for enumCase in self.cases {
            
            IR.append(self.name + " ")
            
            IR.append("_\(self.name)Create\(enumCase.caseName)Case")
            IR.append("(")
            IR.append(enumCase.associatedValues.map { $0.emit(to: language).trimLast() }.joined(separator: ","))
            IR.append(")")
            
            IR.append(" {\n")
            
                
            IR.append("\t\(self.name) \(self.name.camelCased()) = (\(self.name)) {\n")
            
            
            for nullCaseName in self.cases {
                IR.append("\t\t.\(nullCaseName.caseName) = 0,\n")
            }
            

            IR.append("\t};\n")
            
            IR.append("\t")
            
            
            // This is the case we should set a value for
            let validCase = self.cases.filter({ $0.caseName == enumCase.caseName }).first!
            
            // ex., _ExpressionAddition
            let caseTypeName = "_" + self.name + validCase.caseName
            IR.append("\(caseTypeName) \(validCase.caseName) = (\(caseTypeName)) {")
            IR.append("\n")

            
            // Use map over enumerate() to not emit trailing comma
            let memberAssignExpressions = validCase.associatedValues.map {
                let memberNameToSet = $0.identifier
                
                let expr = ".\(memberNameToSet) = \(memberNameToSet)"
                return expr
            }.joined(separator: ",\n\t\t")
            
            IR.append("\t\t" + memberAssignExpressions)
            
            IR.append("\n\t};\n")
            
            ///
            /// Set the primary struct's member
            ///
            
            IR.append("\t")
            IR.append("\(self.name.camelCased()).\(validCase.caseName) = \(validCase.caseName);")
            IR.append("\n")
            
            ///
            
            IR.append("\t")
            IR.append("return \(self.name.camelCased());")
            
            IR.append("\n}\n")
        }
        
        
        return IR
    }
}

extension EnumCaseDefinitionNode: IREmitable {
    public func emit(to language: Language) -> IR {
        let structName = "_\(self.enumName + self.caseName)"
        return emitStruct(structName: structName, cases: self.associatedValues, language: language)
    }
}

extension EnumNode: IREmitable {
    public func emit(to language: Language) -> IR {
        var IR = ""
        let parameterList = self.arguments.map { $0.emit(to: language) }.joined(separator: ",")
        IR.append("_\(self.enumName)Create\(self.caseName)Case(\(parameterList))")
        return IR
    }
}

