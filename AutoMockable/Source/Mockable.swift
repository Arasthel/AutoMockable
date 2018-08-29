//
//  Mockable.swift
//  MockKit
//
//  Created by Jorge Martín on 20/07/2018.
//  Copyright © 2018 Jorge Martín. All rights reserved.
//

import Foundation

public protocol Mockable {
    /// Reference to the Mock Type linked to this Type
    associatedtype MockedType: Mock
}
