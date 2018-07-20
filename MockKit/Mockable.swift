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
    associatedtype When
    
    init()
    func when() -> When
    var callHandler: CallHandler { get set }
    
}

extension Mock {
    
    public func when<ReturnType>(_ closure: ((When) -> MethodStub<ReturnType>)) -> MethodStub<ReturnType> {
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
    let callHandler: CallHandler
    
    public var callCount: Int = 0
    var returnClosure: (() -> ReturnType)?
    
    public init(identifier: String, argMatchers: [Matcher], callHandler: CallHandler) {
        self.identifier = identifier
        self.argMatchers = argMatchers
        self.callHandler = callHandler
    }
    
    public func thenReturn(_ returnValue: @escaping @autoclosure () -> ReturnType) {
        self.returnClosure = returnValue
        callHandler.registerMethodStub(self)
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
    
    public var callHandler = CallHandler()
    
    public typealias MockMethodId = MethodId
    
    public enum MethodId: Int {
        case asda
    }
    
    public required init() {}
    
    private lazy var whenInstance = { When(callHandler: callHandler) }()
    
    public func asda(value: Int) -> Int {
        return callHandler.acceptCall(of: TestMock.self,
                                      method: .asda,
                                      args: [value],
                                      defaultReturnValue: 1)
    }
    
    public func when() -> WhenTestMock {
        return whenInstance
    }
    
}

extension TestMock {
    
    public typealias MockedType = TestMock
    public typealias When = WhenTestMock
    
}

public class WhenTestMock {
    
    let callHandler: CallHandler
    
    private var stubs = [TestMock.MethodId: [MethodStubProtocol]]()
    
    public init(callHandler: CallHandler) {
        self.callHandler = callHandler
    }
    
    public func asda(value: Matcher) -> MethodStub<Int> {
        let identifier = TestMock.identifier(for: .asda)
        return MethodStub<Int>(identifier: identifier, argMatchers: [value], callHandler: callHandler)
    }
    
}
