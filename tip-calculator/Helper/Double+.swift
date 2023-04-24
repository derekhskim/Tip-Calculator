//
//  Double+.swift
//  tip-calculator
//
//  Created by Derek Kim on 2023-04-24.
//

import Foundation

extension Double {
    var currencyFormatted: String {
        var isWholeNumber: Bool {
            isZero ? true: !isNormal ? false: self == rounded()
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = isWholeNumber ? 0 : 2
        return formatter.string(for: self) ?? ""
    }
}
