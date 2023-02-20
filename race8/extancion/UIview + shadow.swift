//
//  UIview + shadow.swift
//  lesson8_HM(race)
//
//  Created by Pavel Nesterenko on 30.06.22.
//

import UIKit

extension UIView {
    // этот extancion позволяет удобно добавить тень
    func addShadow(_ color: UIColor, _ opacity: Float, _ shadowRadius: CGFloat, _ offset: CGSize) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = offset
    }
}
