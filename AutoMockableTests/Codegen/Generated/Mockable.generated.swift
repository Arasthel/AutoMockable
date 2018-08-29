// Generated using Sourcery 0.13.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import AutoMockable






public extension TestClass {
    typealias MockedType = MockTestClass
}

// ==================================================================
// MARK: MockTestClass
// ==================================================================

public class MockTestClass: TestClass, Mock {
	
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
		set { callHandler.acceptCall(method: "a_setter", args: [newValue]) }
		get { return callHandler.acceptCall(method: "a_getter", args: [], defaultReturnValue: Dummy<Int>.value) }
	}


	/// Methods
	override public func asda(_ test: [Int : String]) throws -> Int {
		return try callHandler.acceptThrowingCall(method: "asda(_ test: [Int : String]) throws -> Int", args: [test], defaultReturnValue: Dummy<Int>.value)
	}
	override public func asda(value: [Int]) throws -> Int {
		return try callHandler.acceptThrowingCall(method: "asda(value: [Int]) throws -> Int", args: [value], defaultReturnValue: Dummy<Int>.value)
	}
	override public func asda(value: String?) -> String {
		return callHandler.acceptCall(method: "asda(value: String?) -> String", args: [value], defaultReturnValue: Dummy<String>.value)
	}


	public func getCallHandler() -> CallHandler {
        return callHandler
    }

	public class MockTestClassCallHandler: MethodCallHandler {

        override public init() {
            super.init()
        }

		lazy var a: Property<Int> = {
			Property<Int>(getterIdentifier: "a_getter", setterIdentifier: "a_setter", callHandler: self)
		}()


		func asda(_ test: Matcher<[Int : String]>) -> ThrowableMethodStub<Int> {
			let identifier = "asda(_ test: [Int : String]) throws -> Int"
			let stub = findStub(identifier: identifier, matching: [test]) as? ThrowableMethodStub<Int>
			return stub ?? registerThrowingStub(identifier: identifier, argMatchers: [test], returnType: Int.self)
		}
		func asda(value: Matcher<[Int]>) -> ThrowableMethodStub<Int> {
			let identifier = "asda(value: [Int]) throws -> Int"
			let stub = findStub(identifier: identifier, matching: [value]) as? ThrowableMethodStub<Int>
			return stub ?? registerThrowingStub(identifier: identifier, argMatchers: [value], returnType: Int.self)
		}
		func asda(value: Matcher<String?>) -> MethodStub<String> {
			let identifier = "asda(value: String?) -> String"
			let stub = findStub(identifier: identifier, matching: [value]) as? MethodStub<String>
			return stub ?? registerStub(identifier: identifier, argMatchers: [value], returnType: String.self)
		}

	}

}

// ==================================================================
// MARK: MockTestProtocol
// ==================================================================

public class MockTestProtocol: TestProtocol, Mock {
	
    public typealias CallHandler = MockTestProtocolCallHandler
    private let callHandler = MockTestProtocol.CallHandler()

    /// Needed because of Mockable protocol
    public typealias MockedType = MockTestProtocol

    /// Initializers
	required public init() {}

	/// Properties
	public var b: Int {
		get { return callHandler.acceptCall(method: "b_getter", args: [], defaultReturnValue: Dummy<Int>.value) }
	}


	/// Methods
	public func asda(value: Int) -> Int {
		return callHandler.acceptCall(method: "asda(value: Int) -> Int", args: [value], defaultReturnValue: Dummy<Int>.value)
	}


	public func getCallHandler() -> CallHandler {
        return callHandler
    }

	public class MockTestProtocolCallHandler: MethodCallHandler {

        override public init() {
            super.init()
        }

		lazy var b: ReadOnlyProperty<Int> = {
			ReadOnlyProperty<Int>(getterIdentifier: "b_getter", callHandler: self)
		}()


		func asda(value: Matcher<Int>) -> MethodStub<Int> {
			let identifier = "asda(value: Int) -> Int"
			let stub = findStub(identifier: identifier, matching: [value]) as? MethodStub<Int>
			return stub ?? registerStub(identifier: identifier, argMatchers: [value], returnType: Int.self)
		}

	}

}

enum Mocks {
	static func TestProtocol() -> MockTestProtocol { return MockTestProtocol() }
	static func TestClass(a: Int) -> MockTestClass { return MockTestClass(a: a) }
}
