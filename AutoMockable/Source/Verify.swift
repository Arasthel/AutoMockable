//
//  Verify.swift
//  MockKit
//
//  Created by Jorge Martín Espinosa on 02/08/2018.
//  Copyright © 2018 Jorge Martín. All rights reserved.
//

import Foundation

/// Helper class that holds both a reference to a method stub and a `VerifyCondition` to check.
public class Verify {
    
    let method: MethodStubProtocol
    let called: VerifyCondition
    
    public init(_ method: MethodStubProtocol, called: VerifyCondition) {
        self.method = method
        self.called = called
    }
    
    /**
     Checks if the `VerifyCondition` is satisfied.
     
     - returns: Whether the `VerifyCondition` is satisfied.
     */
    public func isSatisfied() -> Bool {
        return called.isSatisfied(by: method)
    }
    
}

/// Enum used to verify the number of times a method was called
public enum VerifyCondition: CustomStringConvertible {
    case atLeast(Int)
    case times(Int)
    case atMost(Int)
    case never
    
    public func isSatisfied(by stub: MethodStubProtocol) -> Bool {
        switch self {
        case .atLeast(let times):
            return stub.getMatchedCalls() >= times
        case .times(let times):
            return stub.getMatchedCalls() == times
        case .atMost(let times):
            return stub.getMatchedCalls() <= times
        case .never:
            return stub.getMatchedCalls() == 0
        }
    }
    
    public var description: String {
        switch self {
        case .atLeast(let times):
            return "at least \(times) time(s)"
        case .times(let times):
            return "exactly \(times) time(s)"
        case .atMost(let times):
            return "at most \(times) time(s)"
        case .never:
            return "never"
        }
    }
}

/// Extension to add `verify` syntactic sugar to `Mock` objects
extension Mock {
    @discardableResult
    func verify(_ method: (Self.CallHandler) -> MethodStubProtocol, called: VerifyCondition = .times(1), message: String? = nil, file: String = #file, line: Int = #line) -> Bool {
        let function = method(self.getCallHandler())
        let result = Verify(function, called: called).isSatisfied()
        if !result {
            // If MockFailer is configured, this will stop the testing process
            let messageToPrint = message ?? "Expected \(function.name) to be called \(called.description) instead of \(function.getMatchedCalls())"
            MockFailer.instance?.fail(messageToPrint, file: file, line: line)
        }
        return result
    }
}
