//
//  Sample.swift
//  Tests
//
//  Created by Kosuke on 2023/03/05.
//

@testable import App
import XCTest

final class SampleTest: XCTestCase {
    func testExample() throws {
        XCTAssertEqual(10, [1, 2, 3, 4].reduce(0, {$0 + $1}))
    }
}
