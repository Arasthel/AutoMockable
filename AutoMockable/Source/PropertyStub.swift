//
//  Property.swift
//  MockKit
//
//  Created by Jorge Martín Espinosa on 02/08/2018.
//  Copyright © 2018 Jorge Martín. All rights reserved.
//

import Foundation

public class Property<ReturnType> {
    
    let callHandler: MethodCallHandler
    let getterIdentifier: String
    let setterIdentifier: String
    
    public init(getterIdentifier: String, setterIdentifier: String, callHandler: MethodCallHandler) {
        self.getterIdentifier = getterIdentifier
        self.setterIdentifier = setterIdentifier
        self.callHandler = callHandler
    }
    
    public func get() -> MethodStub<ReturnType> {
        let stub = callHandler.findStub(identifier: getterIdentifier, forArgs: []) as? MethodStub<ReturnType>
        return stub ?? callHandler.registerStub(identifier: getterIdentifier, argMatchers: [], returnType: ReturnType.self)
    }
    
    public func set(_ matcher: ArgMatcher) -> MethodStub<Void> {
        let stub = callHandler.findStub(identifier: setterIdentifier, forArgs: [matcher]) as? MethodStub<Void>
        return stub ?? callHandler.registerStub(identifier: setterIdentifier, argMatchers: [matcher], returnType: Void.self)
    }
    
}

public class ReadOnlyProperty<ReturnType> {
    
    let callHandler: MethodCallHandler
    let getterIdentifier: String
    
    public init(getterIdentifier: String, callHandler: MethodCallHandler) {
        self.getterIdentifier = getterIdentifier
        self.callHandler = callHandler
    }
    
    public func get() -> MethodStub<ReturnType> {
        let stub = callHandler.findStub(identifier: getterIdentifier, forArgs: []) as? MethodStub<ReturnType>
        return stub ?? callHandler.registerStub(identifier: getterIdentifier, argMatchers: [], returnType: ReturnType.self)
    }
    
}
