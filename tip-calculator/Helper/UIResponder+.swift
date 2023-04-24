//
//  UIResponder+.swift
//  tip-calculator
//
//  Created by Derek Kim on 2023-04-24.
//

import UIKit

extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
