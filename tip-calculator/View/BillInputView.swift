//
//  BillInputView.swift
//  tip-calculator
//
//  Created by Derek Kim on 2023-04-23.
//

import UIKit

class BillInputView: UIView {
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        backgroundColor = .green
    }
    
}
