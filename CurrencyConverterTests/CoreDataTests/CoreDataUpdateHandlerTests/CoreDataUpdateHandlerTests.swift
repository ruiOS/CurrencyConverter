//
//  CoreDataUpdateHandlerTests.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import XCTest
@testable import CurrencyConverter

final class CoreDataUpdateHandlerTests: XCTestCase {

    let coreDataUpdate = CoreDataUpdateHandler()

    override func setUp() {
        super.setUp()
        let _  = PersistentStorage.shared.context
    }
    
    func testUpdateCoreData() {

        let expectation1 = XCTestExpectation(description: "Perform core data update")
        let expectation2 = XCTestExpectation(description: "Perform backGroundTask update")

        // Calling from backGroundQueue thread since backGroundQueue sometimes is not getting executed and the code consists of back ground queue
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.coreDataUpdate.updateCoreData({
                expectation1.fulfill()
            }, backGroundThreadTask: {
                expectation2.fulfill()
            })
            self?.wait(for: [expectation1, expectation2], timeout: 5)
        }
    }

    func test_CoreDataUpdateTaskExecutesFirst() {
        let waiter = XCTWaiter()

        let expectation1 = XCTestExpectation(description: "Perform core data update")
        let expectation2 = XCTestExpectation(description: "Perform backGroundTask update")

        // Calling from backGroundQueue thread since backGroundQueue sometimes is not getting executed and the code consists of back ground queue
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.coreDataUpdate.updateCoreData({
                expectation1.fulfill()
            }, backGroundThreadTask: {
                expectation2.fulfill()
            })

            let result = waiter.wait(for: [expectation1, expectation2], timeout: 5)
            if result == .completed {
                let firstFulfilledExpectation = waiter.fulfilledExpectations.first
                XCTAssertEqual(firstFulfilledExpectation, expectation1)
            } else {
                XCTFail("Expectations were not fulfilled within the timeout")
            }
        }
    }
}
