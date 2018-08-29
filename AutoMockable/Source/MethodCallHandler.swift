//
//  MethodCallHandler.swift
//  MockKit
//
//  Created by Jorge Martín Espinosa on 02/08/2018.
//  Copyright © 2018 Jorge Martín. All rights reserved.
//

import Foundation

open class MethodCallHandler {
    
    private var stubs = [String : [MethodStubProtocol]]()
    private var recordedCalls = [String : [[Any?]]]()
    
    public init() {}
    
    //======================================================================
    // MARK: Register method stubs
    //======================================================================
    
    /**
     Registers a method stub that can modify the returned value of this method.
     
     - parameter identifier: Method identifier inside its containing `Mock`
     - parameter argMatchers: Matchers of arguments that need to be satisfied to consider this stub 'called'
     - parameter returnType: Return type of the original method
     - parameter methodName: Original method name
     - returns: A method stub for the selected method and arguments
     */
    @discardableResult
    public func registerStub<ReturnType>(identifier: String, argMatchers: [ArgMatcher], returnType: ReturnType.Type, methodName: String = #function) -> MethodStub<ReturnType> {
        var methodStubs = stubs[identifier] ?? []
        let stub = MethodStub<ReturnType>(identifier: identifier, argMatchers: argMatchers, when: self, name: methodName)
        methodStubs.append(stub)
        stubs[identifier] = methodStubs
        return stub
    }
    
    /**
     Registers a throwable method stub that can modify the returned value of this method or throw an Error.
     
     - parameter identifier: Method identifier inside its containing `Mock`
     - parameter argMatchers: Matchers of arguments that need to be satisfied to consider this stub 'called'
     - parameter returnType: Return type of the original method
     - parameter methodName: Original method name
     - returns: A throwable method stub for the selected method and arguments
     */
    @discardableResult
    public func registerThrowingStub<ReturnType>(identifier: String, argMatchers: [ArgMatcher], returnType: ReturnType.Type, methodName: String = #function) -> ThrowableMethodStub<ReturnType> {
        var methodStubs = stubs[identifier] ?? []
        let stub = ThrowableMethodStub<ReturnType>(identifier: identifier, argMatchers: argMatchers, when: self, name: methodName)
        methodStubs.append(stub)
        stubs[identifier] = methodStubs
        return stub
    }
    
    /**
     Finds the first method stub that matches the supplied arguments.
     
     - parameter identifier: Method identifier inside its containing `Mock`
     - parameter args: Arguments that needs to be matched by the stub's `ArgMatcher`s
     - returns: A method stub for the selected method and arguments
     */
    public func findStub(identifier: String, forArgs args: [Any?]) -> MethodStubProtocol? {
        let methodStubs = stubs[identifier]
        return methodStubs?.first(where: { $0.matches(args: args) })
    }
    
    /**
     Finds the first method stub that has the supplied `ArgMatcher`s.
     
     - parameter identifier: Method identifier inside its containing `Mock`
     - parameter matching: `ArgMatcher`s to look for on the `Mock`'s method stubs
     - returns: A method stub for the selected method and matchers
     */
    public func findStub(identifier: String, matching argMatchers: [ArgMatcher]) -> MethodStubProtocol? {
        let methodStubs = stubs[identifier]
        return methodStubs?.first(where: { $0.equalsMatchers(argMatchers) })
    }
    
    //======================================================================
    // MARK: Intercept calls
    //======================================================================
    
    /**
     Called when a `Mock` receives a call to a stubbed method.
     
     - parameter method: Method identifier inside its containing `Mock`
     - parameter args: Arguments supplied to the `Mock` on this call to the stubbed method
     - parameter defaultReturnValue: Value to return if this method hasn't been given another one using `thenReturn`
     - returns: A value of the supplied `ReturnType`
     */
    public func acceptCall<ReturnType>(method: String, args: [Any?], defaultReturnValue: ReturnType) -> ReturnType {
        let matchingStub = findStub(identifier: method, forArgs: args)
        recordCall(toMethod: method, args: args)
        return (matchingStub?.call() as? ReturnType) ?? defaultReturnValue
    }
    
    /**
     Called when a `Mock` receives a call to a stubbed method that may throw an Error.
     
     - parameter method: Method identifier inside its containing `Mock`
     - parameter args: Arguments supplied to the `Mock` on this call to the stubbed method
     - parameter defaultReturnValue: Value to return if this method hasn't been given another one using `thenReturn`
     - returns: A value of the supplied `ReturnType` of a thrown Error
     */
    public func acceptThrowingCall<ReturnType>(method: String, args: [Any?], defaultReturnValue: ReturnType) throws -> ReturnType {
        let matchingStub = findStub(identifier: method, forArgs: args) as? ThrowableMethodStub<ReturnType>
        recordCall(toMethod: method, args: args)
        return (try matchingStub?.tryCall() as? ReturnType) ?? defaultReturnValue
    }
    
    /**
     Called when a `Mock` receives a call to a stubbed method with `Void` return type.
     
     - parameter method: Method identifier inside its containing `Mock`
     - parameter args: Arguments supplied to the `Mock` on this call to the stubbed method
     - returns: A value of the supplied `ReturnType`
     */
    public func acceptCall(method: String, args: [Any?]) {
        let matchingStub = findStub(identifier: method, forArgs: args)
        recordCall(toMethod: method, args: args)
        _ = matchingStub?.call()
    }
    
    /**
     Records a single call to the selected method on the containing `Mock` object, along with its arguments.
     
     - parameter method: Method identifier inside its containing `Mock`
     - parameter args: Arguments supplied to the `Mock` on this call to the stubbed method
     */
    func recordCall(toMethod method: String, args: [Any?]) {
        var callsForMethod = recordedCalls[method] ?? []
        callsForMethod.append(args)
        recordedCalls[method] = callsForMethod
    }
    
    /**
     Gets all recorded calls to the selected method.
     
     - parameter method: Method identifier inside its containing `Mock`
     - returns: All the arguments passed on the recorded method calls
     */
    func getCalls(forMethod method: String) -> [[Any?]] {
        return recordedCalls[method] ?? []
    }
    
}
