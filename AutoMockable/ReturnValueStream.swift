//
//  ReturnValueStream.swift
//  MockKit
//
//  Created by Jorge Martín Espinosa on 03/08/2018.
//  Copyright © 2018 Jorge Martín. All rights reserved.
//

import Foundation

public class ReturnValueStream<T> {
    
    var values = [ReturnStreamValue<T>]()
    
    @discardableResult
    public func thenReturn(_ value: @escaping @autoclosure () -> T) -> ReturnValueStream {
        values.append(ReturnStreamValue(value: value, times: 1))
        return self
    }
    
    @discardableResult
    public func thenReturn(_ returnValue: @escaping @autoclosure () -> T, times: Int) -> ReturnValueStream<T> {
        guard times > 0 else { return self }
        values.append(ReturnStreamValue(value: returnValue, times: times))
        return self
    }
    
    func getReturnValue() -> T? {
        guard let firstValue = values.first else { return nil }
        
        firstValue.times -= 1
        
        if firstValue.times == 0 {
            values.removeFirst()
        }
        
        return firstValue.getValue()
    }
    
}

public class ThrowableReturnValueStream<T>: ReturnValueStream<T> {
    
    @discardableResult
    public func thenThrow(_ error: @escaping @autoclosure () -> (Error)) -> ThrowableReturnValueStream<T> {
        values.append(ReturnStreamValue(error: error, times: 1))
        return self
    }
    
    @discardableResult
    public func thenThrow(_ error: @escaping @autoclosure () -> (Error), times: Int) -> ThrowableReturnValueStream<T> {
        values.append(ReturnStreamValue(error: error, times: times))
        return self
    }
    
    func getReturnValueOrThrow() throws -> T? {
        guard let firstValue = values.first else { return nil }
        
        firstValue.times -= 1
        
        if firstValue.times == 0 {
            values.removeFirst()
        }
        
        return try firstValue.getValueOrThrow()
    }
    
}

class ReturnStreamValue<T> {
    let value: (() -> (T))?
    let error: (() -> (Error))?
    var times: Int
    
    init(value: @escaping () -> (T), times: Int) {
        self.value = value
        self.times = times
        self.error = nil
    }
    
    init(error: @escaping () -> (Error), times: Int) {
        self.value = nil
        self.times = times
        self.error = error
    }
    
    func getValue() -> T? {
        return value?()
    }
    
    func getValueOrThrow() throws -> T? {
        if error != nil {
            throw error!()
        } else {
            return value?()
        }
    }
}
