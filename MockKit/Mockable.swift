//
//  Mockable.swift
//  MockKit
//
//  Created by Jorge Martín on 20/07/2018.
//  Copyright © 2018 Jorge Martín. All rights reserved.
//

import Foundation

public protocol Mock {
    
    associatedtype MockMethodId: RawRepresentable
    associatedtype CallHandler
    
    init()
    func when() -> CallHandler
    
}

extension Mock {
    
    public func when<ReturnType>(_ closure: ((CallHandler) -> MethodStub<ReturnType>)) -> MethodStub<ReturnType> {
        let when = self.when()
        let methodStub = closure(when)
        return methodStub
    }
    
    static func identifier(for mockMethod: MockMethodId) -> String {
        return "method-\(mockMethod.rawValue)"
    }
    
}

public protocol Mockable {
    associatedtype MockedType: Mock
}


public func mock<T: Mockable>(_ mockable: T.Type) -> T.MockedType {
    return T.MockedType.init()
}

public protocol MethodStubProtocol {
    
    var callCount: Int { get set }
    var identifier: String { get }
    var argMatchers: [Matcher] { get }
    func matches(args: [Any?]) -> Bool
    func call() -> Any
    
}

public class MethodStub<ReturnType>: MethodStubProtocol, Hashable {
    
    public let identifier: String
    public let argMatchers: [Matcher]
    public let when: CallHandler
    
    public var callCount: Int = 0
    var returnClosure: (() -> ReturnType)?
    
    public init(identifier: String, argMatchers: [Matcher], when: CallHandler) {
        self.identifier = identifier
        self.argMatchers = argMatchers
        self.when = when
    }
    
    public func thenReturn(_ returnValue: @escaping @autoclosure () -> ReturnType) {
        self.returnClosure = returnValue
    }
    
    public func matches(args: [Any?]) -> Bool {
        guard args.count == argMatchers.count else { return false }
        
        for i in 0..<args.count {
            let matcher = argMatchers[i]
            let arg = args[i]
            if !matcher.matches(value: arg) { return false }
        }
        
        return true
    }
    
    public func call() -> Any {
        callCount += 1
        return returnClosure!() as Any
    }
    
    public var hashValue: Int { return identifier.hashValue }
    public static func ==(lhs: MethodStub, rhs: MethodStub) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
}

public protocol TestProtocol: Mockable {
    
    func asda(value: Int) -> Int
    
}

public class TestMock: TestProtocol, Mock {
        
    public typealias MockMethodId = MethodId
    
    public enum MethodId: Int {
        case asda_value
    }
    
    public required init() {}
    
    private let callHandler = CallHandler()
    
    public func asda(value: Int) -> Int {
        return callHandler.acceptCall(method: TestMock.identifier(for: .asda_value),
                                       args: [value],
                                       defaultReturnValue: 1)
    }
    
    public func when() -> WhenTestMock {
        return callHandler
    }
    
}

extension TestMock {
    
    public typealias MockedType = TestMock
    public typealias CallHandler = WhenTestMock
    
}

public class CallHandler {
    
    private var stubs = [String: [MethodStubProtocol]]()
    
    @discardableResult
    public func registerStub<ReturnType>(identifier: String, argMatchers: [Matcher], returnType: ReturnType.Type) -> MethodStub<ReturnType> {
        var methodStubs = stubs[identifier] ?? []
        let stub = MethodStub<ReturnType>(identifier: identifier, argMatchers: argMatchers, when: self)
        methodStubs.append(stub)
        stubs[identifier] = methodStubs
        return stub
    }
    
    public func findStub(identifier: String, forArgs args: [Any?]) -> MethodStubProtocol? {
        let methodStubs = stubs[identifier]
        return methodStubs?.first(where: { $0.matches(args: args )})
    }
    
    public func acceptCall<ReturnType>(method: String, args: [Any?], defaultReturnValue: ReturnType) -> ReturnType {
        let matchingStub = findStub(identifier: method, forArgs: args)
        return (matchingStub?.call() as? ReturnType) ?? defaultReturnValue
    }
    
}


public class WhenTestMock: CallHandler {
    
    public func asda(value: Matcher) -> MethodStub<Int> {
        let identifier = TestMock.identifier(for: .asda_value)
        let stub = findStub(identifier: identifier, forArgs: [value]) as? MethodStub<Int>
        return stub ?? registerStub(identifier: identifier, argMatchers: [value], returnType: Int.self)
    }
    
}

public class Verify<MockType: Mock> {
    
    let mock: MockType
    let condition: VerifyCondition
    
    init(mock: MockType, condition: VerifyCondition) {
        self.mock = mock
        self.condition = condition
    }
    
}

struct VerifyCondition {
    
}
