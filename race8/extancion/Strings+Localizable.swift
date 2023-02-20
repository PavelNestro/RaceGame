//
//  Strings+Localizable.swift
//  race8
//
//  Created by Pavel Nesterenko on 4.12.22.
//

import Foundation

extension String {
    var localized: String {
        return (NSLocalizedString(self, comment: ""))
    }
}
