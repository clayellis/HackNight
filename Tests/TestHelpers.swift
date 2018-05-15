//
//  TestHelpers.swift
//  YahtzeeTests
//
//  Created by Clay Ellis on 5/14/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import XCTest

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
