//
//  Matcher.swift
//  MockKit
//
//  Created by Jorge Martín on 20/07/2018.
//  Copyright © 2018 Jorge Martín. All rights reserved.
//

import Foundation

public protocol Matcher {
    
    func matches(value: Any?) -> Bool
    
}

public struct AnyMatcher: Matcher {
    
    public func matches(value: Any?) -> Bool {
        return true
    }
    
}
public func any() -> AnyMatcher {
    return AnyMatcher()
}

public struct ValueMatcher<T: Equatable>: Matcher {
    
    let valueToMatch: T
    
    public func matches(value: Any?) -> Bool {
        guard let mappedValue = value as? T else { return false }
        return mappedValue == valueToMatch
    }
    
}
public func theValue<T>(_ value: T) -> ValueMatcher<T> {
    return ValueMatcher<T>(valueToMatch: value)
}

public struct TypeMatcher<T: Any>: Matcher {
    
    let typeToMatch: T.Type
    
    public func matches(value: Any?) -> Bool {
        return type(of: value) == typeToMatch
    }
    
}
public func any<T>(_ type: T.Type) -> TypeMatcher<T> {
    return TypeMatcher<T>(typeToMatch: type)
}

public struct AnyOfListValueMatcher<T: Equatable>: Matcher {
    
    let valuesToMatch: [T]
    
    public func matches(value: Any?) -> Bool {
        guard let mappedValue = value as? T else { return false }
        for valueToMatch in valuesToMatch {
            if mappedValue == valueToMatch { return true }
        }
        return false
    }
    
}
public func any<T: Equatable>(of values: [T]) -> AnyOfListValueMatcher<T> {
    return AnyOfListValueMatcher(valuesToMatch: values)
}

public struct PassingConditionMatcher<T>: Matcher {
    let condition: ((T) -> Bool)
    
    public func matches(value: Any?) -> Bool {
        guard let mappedValue = value as? T else { return false }
        return condition(mappedValue)
    }
}
public func any<T>(passing condition: @escaping ((T) -> Bool)) -> PassingConditionMatcher<T> {
    return PassingConditionMatcher(condition: condition)
}
