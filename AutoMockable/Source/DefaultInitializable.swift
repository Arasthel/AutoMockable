//
//  DefaultInitializable.swift
//  MockKit
//
//  Created by Jorge Martín Espinosa on 27/07/2018.
//  Copyright © 2018 Jorge Martín. All rights reserved.
//

import Foundation

public protocol DefaultInitializable {
    init()
}

public class Dummy<T> {}

public extension Dummy where T : DefaultInitializable {
    public static var value: T { return T() }
}

//======================================================================
// MARK: Extend Swift Data Types
//======================================================================
extension Float: DefaultInitializable {}
extension Double: DefaultInitializable {}
extension UInt: DefaultInitializable {}
extension UInt8: DefaultInitializable {}
extension UInt16: DefaultInitializable {}
extension UInt32: DefaultInitializable {}
extension UInt64: DefaultInitializable {}
extension Int: DefaultInitializable {}
extension Int8: DefaultInitializable {}
extension Int16: DefaultInitializable {}
extension Int32: DefaultInitializable {}
extension Int64: DefaultInitializable {}
extension Decimal: DefaultInitializable {}
extension Bool: DefaultInitializable {}
extension NSNumber: DefaultInitializable {}
extension String: DefaultInitializable {}
extension Date: DefaultInitializable {}
