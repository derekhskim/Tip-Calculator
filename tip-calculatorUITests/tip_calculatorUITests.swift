//
//  tip_calculatorUITests.swift
//  tip-calculatorUITests
//
//  Created by Derek Kim on 2023-04-23.
//

import XCTest

final class tip_calculatorUITests: XCTestCase {

    private var app: XCUIApplication!
    
    private var screen: CalculatorScreen {
        CalculatorScreen(app: app)
    }
    
    override func setUp() {
        super.setUp()
        app = .init()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app = nil
    }
    
    func testResultViewDefaultValues() {
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$0")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$0")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$0")
    }
    
    func testRegularTip() {
        // User enters a $100 bill
        screen.enterBill(amount: 100)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$100")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$100")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$0")
        
        // User selects 15%
        screen.selectTip(tip: .fifteenPercent)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$115")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$115")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$15")

        // User selects 18%
        screen.selectTip(tip: .eighteenPercent)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$118")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$118")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$18")

        // User selects 20%
        screen.selectTip(tip: .twentyPercent)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$120")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$120")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$20")

        // User splits the bill by 4
        screen.selectIncrementButton(numberOfTaps: 3)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$30")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$120")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$20")

        // User splits the bill by 2
        screen.selectDecrementButton(numberOfTaps: 2)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$60")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$120")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$20")
        
    }
    
}
