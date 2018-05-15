//
//  TestHelpers.swift
//  YahtzeeTests
//
//  Created by Clay Ellis on 5/14/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import XCTest
@testable import Yahtzee

//struct UnexpectedErrorType: LocalizedError {
//    let unexpectedError: Error
//    let expectedType: Error.Type
//
//    var errorDescription: String? {
//        return "Test threw unexpected error: \(unexpectedError), expected: \(expectedType)."
//    }
//}

func XCTFailUnexpectedError(_ error: Error, expectedError: Error, file: StaticString = #file, line: UInt = #line) {
    XCTFail("Expected error \(expectedError), but received: \(error)", file: file, line: line)
}

func XCTFailUnexpectedError(_ error: Error, expectedErrorType: Error.Type, file: StaticString = #file, line: UInt = #line) {
    XCTFail("Expected error of type \(expectedErrorType), but received: \(error)", file: file, line: line)
}

extension Roll {
    init(strict d1: Int, _ d2: Int, _ d3: Int, _ d4: Int, _ d5: Int) throws {
        try self.init(d1, d2, d3, d4, d5)
    }
}
