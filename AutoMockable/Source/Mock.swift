//
//  Mock.swift
//  MockKit
//
//  Created by Jorge Martín Espinosa on 02/08/2018.
//  Copyright © 2018 Jorge Martín. All rights reserved.
//

import Foundation

public protocol Mock {
    
    associatedtype MockMethodId: RawRepresentable
    associatedtype CallHandler
    
    func getCallHandler() -> CallHandler
    
}

extension Mock {
    
    public func when<ReturnType>(_ closure: ((Self.CallHandler) -> MethodStub<ReturnType>)) -> MethodStub<ReturnType> {
        let when = self.getCallHandler()
        let methodStub = closure(when)
        return methodStub
    }
    
    public func when<ReturnType>(_ closure: ((Self.CallHandler) -> ThrowableMethodStub<ReturnType>)) -> ThrowableMethodStub<ReturnType> {
        let when = self.getCallHandler()
        let methodStub = closure(when)
        return methodStub
    }
    
    public static func identifier(for mockMethod: MockMethodId) -> String {
        // If rawValue is a String, use it as the identifier
        if type(of: mockMethod).RawValue.self == String.self {
            return mockMethod.rawValue as! String
        }
        return "method-\(mockMethod.rawValue)"
    }
    
}
