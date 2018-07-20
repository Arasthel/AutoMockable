//
//  MockKitTests.swift
//  MockKitTests
//
//  Created by Jorge Martín on 17/07/2018.
//  Copyright © 2018 Jorge Martín. All rights reserved.
//

import XCTest
@testable import MockKit

class MockKitTests: XCTestCase {
    
    func testExample() {
        let testMock = TestMock()
        testMock.when { $0.asda(value: any()) }.thenReturn(-1)
        let result = testMock.asda(value: 0)
        XCTAssertEqual(-1, result)
    }
    
}
