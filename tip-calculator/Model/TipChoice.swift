//
//  TipChoice.swift
//  tip-calculator
//
//  Created by Derek Kim on 2023-04-23.
//

import Foundation

enum TipChoice {
    case none
    case fifteenPercent
    case eighteenPercent
    case twentyPercent
    case Custom(value: Int)
    
    var stringValue: String {
        switch self {
        case .none:
            return ""
        case .fifteenPercent:
            return "15%"
        case .eighteenPercent:
            return "18%"
        case .twentyPercent:
            return "20%"
        case .Custom(let value):
            return String(value)
        }
    }
}
