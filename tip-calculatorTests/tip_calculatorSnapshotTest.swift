//
//  tip_calculatorSnapshotTest.swift
//  tip-calculatorTests
//
//  Created by Derek Kim on 2023-04-25.
//

import XCTest
import SnapshotTesting
@testable import tip_calculator

final class tip_calculatorSnapshotTests: XCTestCase {
    
    private var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    func testLogoView() {
        // Given
        let size = CGSize(width: screenWidth, height: 48)
        // When
        let view = LogoView()
        // then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testInitialResultView() {
        // Given
        let size = CGSize(width: screenWidth, height: 224)
        // When
        let view = ResultView()
        // then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testResultViewWithValues() {
        // Given
        let size = CGSize(width: screenWidth, height: 224)
        let result = Result(
            amountPerPerson: 100.25,
            totalBill: 45,
            totalTip: 60)
        // When
        let view = ResultView()
        view.configure(result: result)
        // then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testInitialTipInputView() {
        // Given
        let size = CGSize(width: screenWidth, height: 56+56+16)
        // When
        let view = TipInputView()
        // then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testTipInputViewWithSelections() {
        // Given
        let size = CGSize(width: screenWidth, height: 56+56+16)
        // When
        let view = TipInputView()
        let button = view.allSubViewsOf(type: UIButton.self).first
        button?.sendActions(for: .touchUpInside)
        // then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testInitialBillInputView() {
        // Given
        let size = CGSize(width: screenWidth, height: 56)
        // When
        let view = BillInputView()
        // then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testBillInputViewWithValues() {
        // Given
        let size = CGSize(width: screenWidth, height: 56)
        // When
        let view = BillInputView()
        let textField = view.allSubViewsOf(type: UITextField.self).first
        textField?.text = "500"
        // then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testInitialSplitInputView() {
        // Given
        let size = CGSize(width: screenWidth, height: 56)
        // When
        let view = SplitInputView()
        // then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testSplitInputViewWithSelection() {
        // Given
        let size = CGSize(width: screenWidth, height: 56)
        // When
        let view = SplitInputView()
        let button = view.allSubViewsOf(type: UIButton.self).last
        button?.sendActions(for: .touchUpInside)
        // then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
}

extension UIView {
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}
