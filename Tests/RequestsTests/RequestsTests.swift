import XCTest
@testable import Requests

final class RequestsTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Requests().text, "Hello, World!")
    }
}
