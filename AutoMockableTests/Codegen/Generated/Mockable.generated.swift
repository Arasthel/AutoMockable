// Generated using Sourcery 0.13.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import AutoMockable

// Module imports
import UIKit





public extension TestClass {
    typealias MockedType = MockTestClass
}

public class MockTestClass: TestClass, Mock {
	
	/// Method Ids
	public enum MethodId: String {
		case a_getter = "property_a_getter"
		case a_setter = "property_a_setter"
		case asda_value$Int = "asda(value: Int)"
		case asda_value$StringOpt = "asda(value: String?)"
	}

	public typealias MockMethodId = MethodId

    public typealias CallHandler = MockTestClassCallHandler
    private let callHandler = MockTestClass.CallHandler()

    /// Needed because of Mockable protocol
    public typealias MockedType = MockTestClass

    /// Initializers
	override public init(a: Int) { 
		super.init(a: a)
	}


	/// Properties
	override public var a: Int {
		set { callHandler.acceptCall(method: MockTestClass.identifier(for: .a_setter), args: [newValue]) }
		get { return callHandler.acceptCall(method: MockTestClass.identifier(for: .a_getter), args: [], defaultReturnValue: Dummy<Int>.value) }
	}


	/// Methods
	override public func asda(value: Int) throws -> Int {
		return try callHandler.acceptThrowingCall(method: MockTestClass.identifier(for: .asda_value$Int), args: [value], defaultReturnValue: Dummy<Int>.value)
	}
	override public func asda(value: String?) -> String {
		return callHandler.acceptCall(method: MockTestClass.identifier(for: .asda_value$StringOpt), args: [value], defaultReturnValue: Dummy<String>.value)
	}


	public func getCallHandler() -> CallHandler {
        return callHandler
    }

	public class MockTestClassCallHandler: MethodCallHandler {

        override public init() {
            super.init()
        }

		lazy var a: Property<Int> = {
			Property<Int>(getterIdentifier: MockTestClass.identifier(for: .a_getter), setterIdentifier: MockTestClass.identifier(for: .a_setter), callHandler: self)
		}()


		func asda(value: ArgMatcher) -> ThrowableMethodStub<Int> {
			let identifier = MockTestClass.identifier(for: .asda_value$Int)
			let stub = findStub(identifier: identifier, matching: [value]) as? ThrowableMethodStub<Int>
			return stub ?? registerThrowingStub(identifier: identifier, argMatchers: [value], returnType: Int.self)
		}
		func asda(value: ArgMatcher) -> MethodStub<String> {
			let identifier = MockTestClass.identifier(for: .asda_value$StringOpt)
			let stub = findStub(identifier: identifier, matching: [value]) as? MethodStub<String>
			return stub ?? registerStub(identifier: identifier, argMatchers: [value], returnType: String.self)
		}

	}

}

public class MockTestProtocol: TestProtocol, Mock {
	
	/// Method Ids
	public enum MethodId: String {
		case b_getter = "property_b_getter"
		case asda_value$Int = "asda(value: Int)"
	}

	public typealias MockMethodId = MethodId

    public typealias CallHandler = MockTestProtocolCallHandler
    private let callHandler = MockTestProtocol.CallHandler()

    /// Needed because of Mockable protocol
    public typealias MockedType = MockTestProtocol

    /// Initializers
	required public init() {}

	/// Properties
	public var b: Int {
		get { return callHandler.acceptCall(method: MockTestProtocol.identifier(for: .b_getter), args: [], defaultReturnValue: Dummy<Int>.value) }
	}


	/// Methods
	public func asda(value: Int) -> Int {
		return callHandler.acceptCall(method: MockTestProtocol.identifier(for: .asda_value$Int), args: [value], defaultReturnValue: Dummy<Int>.value)
	}


	public func getCallHandler() -> CallHandler {
        return callHandler
    }

	public class MockTestProtocolCallHandler: MethodCallHandler {

        override public init() {
            super.init()
        }

		lazy var b: ReadOnlyProperty<Int> = {
			ReadOnlyProperty<Int>(getterIdentifier: MockTestProtocol.identifier(for: .b_getter), callHandler: self)
		}()


		func asda(value: ArgMatcher) -> MethodStub<Int> {
			let identifier = MockTestProtocol.identifier(for: .asda_value$Int)
			let stub = findStub(identifier: identifier, matching: [value]) as? MethodStub<Int>
			return stub ?? registerStub(identifier: identifier, argMatchers: [value], returnType: Int.self)
		}

	}

}

enum Mocks {
	static func TestProtocol() -> MockTestProtocol { return MockTestProtocol() }
	static func TestClass(a: Int) -> MockTestClass { return MockTestClass(a: a) }
}
