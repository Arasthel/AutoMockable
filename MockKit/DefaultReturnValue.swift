//
//  DefaultReturnValue.swift
//  MockKit
//
//  Created by Jorge Martín on 20/07/2018.
//  Copyright © 2018 Jorge Martín. All rights reserved.
//

import Foundation

class DefaultReturnValues {
    
    static private var returnValues = [ObjectIdentifier : Any]()
    
    static func returnValue<T>(for type: T.Type) -> T {
        return returnValues[ObjectIdentifier(type)] as! T
    }
    
}
