//
//  Extensions.swift
//  LampMindControl
//
//  Created by William Du on 12/9/30 H.
//  Copyright © 30 Heisei William Du. All rights reserved.
//

import Foundation

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue != 0
        }
    }
}
