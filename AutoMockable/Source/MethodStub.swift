//
//  MethodStub.swift
//  MockKit
//
//  Created by Jorge Martín Espinosa on 02/08/2018.
//  Copyright © 2018 Jorge Martín. All rights reserved.
//

import Foundation

public protocol MethodStubProtocol {
    
    var identifier: String { get }
    var argMatchers: [ArgMatcher] { get }
    var name: String { get }
    func matches(args: [Any?]) -> Bool
    func equalsMatchers(_ matchers: [ArgMatcher]) -> Bool
    func call() -> Any?
    func getMatchedCalls() -> Int
    
}

public class MethodStub<ReturnType>: MethodStubProtocol, Hashable {
    
    public let identifier: String
    public let argMatchers: [ArgMatcher]
    public let methodCallHandler: MethodCallHandler
    public let name: String
    
    let returnStream = ReturnValueStream<ReturnType>()
    
    public init(identifier: String, argMatchers: [ArgMatcher], when: MethodCallHandler, name: String) {
        self.identifier = identifier
        self.argMatchers = argMatchers
        self.methodCallHandler = when
        self.name = name
    }
    
    @discardableResult
    public func thenReturn(_ returnValue: @escaping @autoclosure () -> ReturnType) -> ReturnValueStream<ReturnType> {
        return returnStream.thenReturn(returnValue)
    }
    
    @discardableResult
    public func thenReturn(_ returnValue: @escaping @autoclosure () -> ReturnType, times: Int) -> ReturnValueStream<ReturnType> {
        return returnStream.thenReturn(returnValue, times: times)
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
    
    public func call() -> Any? {
        return returnStream.getReturnValue()
    }
    
    public func getMatchedCalls() -> Int {
        let allCalls = methodCallHandler.getCalls(forMethod: identifier)
        return allCalls.filter { self.matches(args: $0) }.count
    }
    
    public func equalsMatchers(_ matchers: [ArgMatcher]) -> Bool {
        guard self.argMatchers.count == matchers.count else { return false }
        
        for i in (0..<argMatchers.count) {
            if !argMatchers[i].equals(matcher: matchers[i]) {
                return false
            }
        }
        
        return true
    }
    
    public var hashValue: Int { return identifier.hashValue }
    public static func ==(lhs: MethodStub, rhs: MethodStub) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.equalsMatchers(rhs.argMatchers)
    }
    
}

public class ThrowableMethodStub<ReturnType>: MethodStubProtocol, Hashable {
    
    public let identifier: String
    public let argMatchers: [ArgMatcher]
    public let methodCallHandler: MethodCallHandler
    public let name: String
    
    let returnStream = ThrowableReturnValueStream<ReturnType>()
    
    public init(identifier: String, argMatchers: [ArgMatcher], when: MethodCallHandler, name: String) {
        self.identifier = identifier
        self.argMatchers = argMatchers
        self.methodCallHandler = when
        self.name = name
    }
    
    @discardableResult
    public func thenReturn(_ returnValue: @escaping @autoclosure () -> ReturnType) -> ThrowableReturnValueStream<ReturnType> {
        return returnStream.thenReturn(returnValue) as! ThrowableReturnValueStream
    }
    
    @discardableResult
    public func thenReturn(_ returnValue: @escaping @autoclosure () -> ReturnType, times: Int) -> ThrowableReturnValueStream<ReturnType> {
        return returnStream.thenReturn(returnValue, times: times) as! ThrowableReturnValueStream
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
    
    public func call() -> Any? {
        return returnStream.getReturnValue()
    }
    
    func tryCall() throws -> Any? {
        return try returnStream.getReturnValueOrThrow()
    }
    
    public func getMatchedCalls() -> Int {
        let allCalls = methodCallHandler.getCalls(forMethod: identifier)
        return allCalls.filter { self.matches(args: $0) }.count
    }
    
    public func thenThrow(_ error: @escaping @autoclosure () -> (Error)) -> ThrowableReturnValueStream<ReturnType> {
        return returnStream.thenThrow(error)
    }
    
    public func thenThrow(_ error: @escaping @autoclosure () -> (Error), times: Int) -> ThrowableReturnValueStream<ReturnType> {
        return returnStream.thenThrow(error, times: times)
    }
    
    public func equalsMatchers(_ matchers: [ArgMatcher]) -> Bool {
        guard self.argMatchers.count == matchers.count else { return false }
        
        for i in (0..<argMatchers.count) {
            if !argMatchers[i].equals(matcher: matchers[i]) {
                return false
            }
        }
        
        return true
    }
    
    public var hashValue: Int { return identifier.hashValue }
    public static func ==(lhs: ThrowableMethodStub, rhs: ThrowableMethodStub) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.equalsMatchers(rhs.argMatchers)
    }
    
}
