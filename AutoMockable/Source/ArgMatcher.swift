//
//  ArgMatcher.swift
//  MockKit
//
//  Created by Jorge Martín on 20/07/2018.
//  Copyright © 2018 Jorge Martín. All rights reserved.
//

import Foundation

public protocol ArgMatcher {
    
    /**
     Checks if the passed value matches this `ArgMatcher`'s criteria
     
     - parameter value: Value passed to check if it maches
     - returns: Whether the `ArgMatcher` is satisfied or not
     */
    func matches(value: Any?) -> Bool
    
    /**
     Used to check if two `ArgMatcher`s can be considered the same
     
     - parameter matcher: Another `ArgMatcher`
     - returns: Whether the two `ArgMatcher`s are equal or not
     */
    func equals(matcher: ArgMatcher) -> Bool
    
}

/// `ArgMatcher` that matches any value. Will always return true.
public struct AnyValueMatcher: ArgMatcher {
    
    public func matches(value: Any?) -> Bool {
        return true
    }
    
    public func equals(matcher: ArgMatcher) -> Bool {
        return matcher is AnyValueMatcher
    }
    
}
/// Syntactic sugar to create an `AnyValueMatcher`.
public func any() -> AnyValueMatcher {
    return AnyValueMatcher()
}

/// `ArgMatcher` that checks whether the provided value equals another concrete one.
public struct ValueMatcher<T: Equatable>: ArgMatcher {
    
    let valueToMatch: T
    
    public func matches(value: Any?) -> Bool {
        guard let mappedValue = value as? T else { return false }
        return mappedValue == valueToMatch
    }
    
    public func equals(matcher: ArgMatcher) -> Bool {
        if let matcher = matcher as? ValueMatcher<T>, matcher.valueToMatch == valueToMatch { return true }
        return false
    }
    
}
/// Syntactic sugar to create a `ValueMatcher` with the supplied value.
public func theValue<T>(_ value: T) -> ValueMatcher<T> {
    return ValueMatcher<T>(valueToMatch: value)
}

/// `ArgMatcher` that checks whether the provided value is of a concrete `Type`.
public struct TypeMatcher<T: Any>: ArgMatcher {
    
    let typeToMatch: T.Type
    
    public func matches(value: Any?) -> Bool {
        return type(of: value) == typeToMatch
    }
    
    public func equals(matcher: ArgMatcher) -> Bool {
        if let matcher = matcher as? TypeMatcher<T>, matcher.typeToMatch == typeToMatch { return true }
        return false
    }
    
}
/// Syntactic sugar to create a `TypeMatcher`.
public func any<T>(_ type: T.Type) -> TypeMatcher<T> {
    return TypeMatcher<T>(typeToMatch: type)
}

/// `ArgMatcher` that checks whether the provided value matches any value of a list.
public struct AnyOfListValueMatcher<T: Equatable>: ArgMatcher {
    
    let valuesToMatch: [T]
    
    public func matches(value: Any?) -> Bool {
        guard let mappedValue = value as? T else { return false }
        for valueToMatch in valuesToMatch {
            if mappedValue == valueToMatch { return true }
        }
        return false
    }
    
    public func equals(matcher: ArgMatcher) -> Bool {
        if let matcher = matcher as? AnyOfListValueMatcher<T>, matcher.valuesToMatch == valuesToMatch { return true }
        return false
    }
    
}
/// Syntactic sugar to create an `AnyOfListValueMatcher`.
public func any<T: Equatable>(of values: [T]) -> AnyOfListValueMatcher<T> {
    return AnyOfListValueMatcher(valuesToMatch: values)
}

/// `ArgMatcher` that checks whether the provided value passes a closure's check.
public struct PassingConditionMatcher<T>: ArgMatcher {
    let condition: ((T) -> Bool)
    
    public func matches(value: Any?) -> Bool {
        
        guard let mappedValue = value as? T else { return false }
        return condition(mappedValue)
    }
    
    public func equals(matcher: ArgMatcher) -> Bool {
        // I wish there was a better way to check this...
        return matcher is PassingConditionMatcher<T>
    }
}
/// Syntactic sugar to create a `PassingConditionMatcher`.
public func any<T>(passing condition: @escaping ((T) -> Bool)) -> PassingConditionMatcher<T> {
    return PassingConditionMatcher(condition: condition)
}
