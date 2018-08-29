//
//  MockKitTests.swift
//  MockKitTests
//
//  Created by Jorge Martín on 17/07/2018.
//  Copyright © 2018 Jorge Martín. All rights reserved.
//

import XCTest
@testable import AutoMockable

class MockKitTests: MockKitTestCase {
    
    func testExample() {
        
        // Protocol
        let testMock = Mocks.TestProtocol()
        
        testMock.when { $0.asda(value: any()) }.thenReturn(-1, times: 2).thenReturn(2)
        XCTAssertEqual(-1, testMock.asda(value: 0))
        XCTAssertEqual(-1, testMock.asda(value: 0))
        XCTAssertEqual(2, testMock.asda(value: 0))
        testMock.verify({ $0.asda(value: any())}, called: .times(3))
        
        testMock.when({ $0.b.get() }).thenReturn(100)
        let testProperty = testMock.b
        XCTAssertEqual(100, testProperty)
        testMock.verify({ $0.b.get() }, called: .times(1))
        
        // Class
        let classMock = Mocks.TestClass(a: 0)
        
        classMock.when { $0.asda(value: any() as AnyValueMatcher<[Int]>) }.thenReturn(-1)
        let resultClass = try! classMock.asda(value: [0])
        XCTAssertEqual(-1, resultClass)
        classMock.verify({ $0.asda(value: any() as AnyValueMatcher<[Int]>) as ThrowableMethodStub<Int> })
        
        classMock.when({ $0.a.get() }).thenReturn(100)
        let testClassProperty = classMock.a
        XCTAssertEqual(100, testClassProperty)
        classMock.verify({ $0.a.get() }, called: .times(1))
    }
    
}
