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

public class Matcher<T>: ArgMatcher {
    
    public func matches(value: Any?) -> Bool {
        return false
    }
    
    public func equals(matcher: ArgMatcher) -> Bool {
        return false
    }
    
}

/// `ArgMatcher` that matches any value. Will always return true.
public class AnyValueMatcher<T>: Matcher<T> {
    
    override public func matches(value: Any?) -> Bool {
        return true
    }
    
    override public func equals(matcher: ArgMatcher) -> Bool {
        return matcher is AnyValueMatcher
    }
    
}
/// Syntactic sugar to create an `AnyValueMatcher`.
public func any<T>() -> AnyValueMatcher<T> {
    return AnyValueMatcher<T>()
}

/// `ArgMatcher` that checks whether the provided value equals another concrete one.
public class ValueMatcher<T: Equatable>: Matcher<T> {
    
    let valueToMatch: T
    
    init(valueToMatch: T) {
        self.valueToMatch = valueToMatch
    }
    
    override public func matches(value: Any?) -> Bool {
        guard let mappedValue = value as? T else { return false }
        return mappedValue == valueToMatch
    }
    
    override public func equals(matcher: ArgMatcher) -> Bool {
        if let matcher = matcher as? ValueMatcher<T>, matcher.valueToMatch == valueToMatch { return true }
        return false
    }
    
}
/// Syntactic sugar to create a `ValueMatcher` with the supplied value.
public func `is`<T>(_ value: T) -> ValueMatcher<T> {
    return ValueMatcher<T>(valueToMatch: value)
}

/// `ArgMatcher` that checks whether the provided value is of a concrete `Type`.
public class TypeMatcher<T: Any>: Matcher<T> {
    
    let typeToMatch: T.Type
    
    init(typeToMatch: T.Type) {
        self.typeToMatch = typeToMatch
    }
    
    override public func matches(value: Any?) -> Bool {
        return type(of: value) == typeToMatch
    }
    
    override public func equals(matcher: ArgMatcher) -> Bool {
        if let matcher = matcher as? TypeMatcher<T>, matcher.typeToMatch == typeToMatch { return true }
        return false
    }
    
}
/// Syntactic sugar to create a `TypeMatcher`.
public func any<T>(_ type: T.Type) -> TypeMatcher<T> {
    return TypeMatcher<T>(typeToMatch: type)
}

/// `ArgMatcher` that checks whether the provided value matches any value of a list.
public class AnyOfListValueMatcher<T: Equatable>: Matcher<T> {
    
    let valuesToMatch: [T]
    
    init(valuesToMatch: [T]) {
        self.valuesToMatch = valuesToMatch
    }
    
    override public func matches(value: Any?) -> Bool {
        guard let mappedValue = value as? T else { return false }
        for valueToMatch in valuesToMatch {
            if mappedValue == valueToMatch { return true }
        }
        return false
    }
    
    override public func equals(matcher: ArgMatcher) -> Bool {
        if let matcher = matcher as? AnyOfListValueMatcher<T>, matcher.valuesToMatch == valuesToMatch { return true }
        return false
    }
    
}
/// Syntactic sugar to create an `AnyOfListValueMatcher`.
public func any<T: Equatable>(of values: [T]) -> AnyOfListValueMatcher<T> {
    return AnyOfListValueMatcher(valuesToMatch: values)
}

/// `ArgMatcher` that checks whether the provided value passes a closure's check.
public class PassingConditionMatcher<T>: Matcher<T> {
    
    let condition: ((T) -> Bool)
    
    init(condition: @escaping ((T) -> Bool)) {
        self.condition = condition
    }
    
    override public func matches(value: Any?) -> Bool {
        
        guard let mappedValue = value as? T else { return false }
        return condition(mappedValue)
    }
    
    override public func equals(matcher: ArgMatcher) -> Bool {
        // I wish there was a better way to check this...
        return matcher is PassingConditionMatcher<T>
    }
}
/// Syntactic sugar to create a `PassingConditionMatcher`.
public func any<T>(passing condition: @escaping ((T) -> Bool)) -> PassingConditionMatcher<T> {
    return PassingConditionMatcher(condition: condition)
}
