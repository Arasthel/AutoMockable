//
//  MockKitTestCase.swift
//  MockKit
//
//  Created by Jorge Martín Espinosa on 02/08/2018.
//  Copyright © 2018 Jorge Martín. All rights reserved.
//

import Foundation
import XCTest

class MockKitTestCase: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        MockFailer.instance = MockFailer(testCase: self)
    }
    
}
