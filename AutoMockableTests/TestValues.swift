//
//  TestValues.swift
//  MockKit
//
//  Created by Jorge Martín Espinosa on 02/08/2018.
//  Copyright © 2018 Jorge Martín. All rights reserved.
//

import Foundation

public protocol TestProtocol {
    var b: Int { get }
    func asda(value: Int) -> Int
}

public class TestClass {
    
    lazy var a: Int = { return 0 }()
    
    init(a: Int) {
        self.a = a
    }
    
    func asda(value: Int) throws -> Int { return 0 }
    func asda(value: String?) -> String { return ""}
}
