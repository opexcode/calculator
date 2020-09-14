//
//  UIExtensions.swift
//  Calc
//
//  Created by Алексей on 14.09.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

// MARK: - Extensions

extension UIView {
    func blink() {
        self.alpha = 0.1
        UIView.animate(withDuration: 0.0,
                       delay: 0.1,
                       options: [.curveLinear,
                                 .autoreverse],
                       animations: { self.alpha = 1.0 },
                       completion: nil)
    }
    
}


extension UIButton {
    func flash() {
        self.alpha = 0.2
        UIView.animate(withDuration: 0.0,
                       delay: 0.0,
                       options: [
                        .autoreverse],
                       animations: { self.alpha = 1.5 },
                       completion: nil)
    }
    
}
