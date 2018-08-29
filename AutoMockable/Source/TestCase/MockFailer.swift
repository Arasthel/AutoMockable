//
//  MockFailer.swift
//  MockKit
//
//  Created by Jorge Martín Espinosa on 02/08/2018.
//  Copyright © 2018 Jorge Martín. All rights reserved.
//

import Foundation
import XCTest

class MockFailer {
    
    static var instance: MockFailer? = nil
    
    let testCase: XCTestCase
    
    init(testCase: XCTestCase) {
        self.testCase = testCase
    }
    
    func fail(_ message: String, file: String, line: Int) {
        testCase.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
    }
    
}
