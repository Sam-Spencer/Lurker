import XCTest
@testable import Lurker

final class LurkerTests: XCTestCase {
    
    func testSetup() throws {
        XCTAssertNotNil(Lurker.shared)
    }
    
}
