//
//  CallHandler.swift
//  MockKit
//
//  Created by Jorge Martín on 17/07/2018.
//  Copyright © 2018 Jorge Martín. All rights reserved.
//

import Foundation

public class CallHandler {
    
    private var stubs = [String: [MethodStubProtocol]]()
    
    public func acceptCall<MockType: Mock, ReturnType>(of mockType: MockType.Type, method: MockType.MockMethodId, args: [Any?], defaultReturnValue: ReturnType) -> ReturnType {
        let matchingStub = findMethodStubMatching(mockType: mockType, method: method, args: args)
        return (matchingStub?.call() as? ReturnType) ?? defaultReturnValue
    }
    
    public func registerMethodStub(_ stub: MethodStubProtocol) {
        var methodStubs = stubs[stub.identifier] ?? []
        methodStubs.append(stub)
        stubs[stub.identifier] = methodStubs
    }
    
    public func findMethodStubMatching<MockType: Mock>(mockType: MockType.Type, method: MockType.MockMethodId, args: [Any?]) -> MethodStubProtocol? {
        let identifier = MockType.identifier(for: method)
        let methodStubs = stubs[identifier] ?? []
        
        return methodStubs.first(where: { $0.matches(args: args )})
    }
    
}
