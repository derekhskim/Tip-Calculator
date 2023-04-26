//
//  tip_calculatorTests.swift
//  tip-calculatorTests
//
//  Created by Derek Kim on 2023-04-23.
//

import XCTest
import Combine
@testable import tip_calculator

final class tip_calculatorTests: XCTestCase {
    
    private var sut: CalculatorVM!
    private var cancellables: Set<AnyCancellable>!
    
    private let logoViewTapSubject = PassthroughSubject<Void, Never>()
    private var audioPlayerService: MockAudioPlayerService!

    override func setUp() {
        audioPlayerService = .init()
        sut = .init(audioPlayerService: audioPlayerService)
        cancellables = .init()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        cancellables = nil
    }
    
    func testResultWithoutTipFor1Person() {
        // Given
        let bill: Double = 100.0
        let tip: TipChoice = .none
        let split: Int = 1
        let input = buildInput(
            bill: bill,
            tip: tip,
            split: split)
        // When
        let output = sut.transform(input: input)
        
        // then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 100)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTip, 0)
        }.store(in: &cancellables)
    }
    
    func testResultWithoutTipFor2Person() {
        // Given
        let bill: Double = 100.0
        let tip: TipChoice = .none
        let split: Int = 2
        let input = buildInput(
            bill: bill,
            tip: tip,
            split: split)
        // When
        let output = sut.transform(input: input)
        // then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 50)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTip, 0)
        }.store(in: &cancellables)
    }
    
    func testResultWith20PercentTipFor2Person() {
        // Given
        let bill: Double = 100.0
        let tip: TipChoice = .twentyPercent
        let split: Int = 2
        let input = buildInput(
            bill: bill,
            tip: tip,
            split: split)
        // When
        let output = sut.transform(input: input)
        
        // then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 60)
            XCTAssertEqual(result.totalBill, 120)
            XCTAssertEqual(result.totalTip, 20)
        }.store(in: &cancellables)
    }
    
    func testResultWithCustomTipFor4Person() {
        // Given
        let bill: Double = 200.0
        let tip: TipChoice = .Custom(value: 40)
        let split: Int = 4
        let input = buildInput(
            bill: bill,
            tip: tip,
            split: split)
        // When
        let output = sut.transform(input: input)
        
        // then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 60)
            XCTAssertEqual(result.totalBill, 240)
            XCTAssertEqual(result.totalTip, 40)
        }.store(in: &cancellables)
    }
    
    func testSoundPlayedAndCalculatorResetOnLogoViewTap() {
        // Given
        let input = buildInput(bill: 100, tip: .fifteenPercent, split: 2)
        let output = sut.transform(input: input)
        let expectation1 = XCTestExpectation(description: "Reset Calculator Called")
        let expectation2 = audioPlayerService.expectation
        // then
        output.resetCalculatorPublisher.sink { _ in
            expectation1.fulfill()
        }.store(in: &cancellables)
        // When
        logoViewTapSubject.send()
        wait(for: [expectation1, expectation2], timeout: 1.0)
    }
    
    private func buildInput(bill: Double, tip: TipChoice, split: Int) -> CalculatorVM.Input {
        return .init(
            billPublisher: Just(bill).eraseToAnyPublisher(),
            tipPublisher: Just(tip).eraseToAnyPublisher(),
            splitPublisher: Just(split).eraseToAnyPublisher(),
            logoViewTapPublisher: logoViewTapSubject.eraseToAnyPublisher())
    }
}

class MockAudioPlayerService: AudioPlayerService {
    var expectation = XCTestExpectation(description: "playSound method is called")
    
    func playSound() {
        expectation.fulfill()
    }
}
