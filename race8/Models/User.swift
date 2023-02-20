//
//  User.swift
//  race8
//
//  Created by Pavel Nesterenko on 13.02.23.
//

import Foundation
import UIKit
import RealmSwift

class User: Object {
    static let sheard = User()
    @Persisted var name: String
    @Persisted var score: Int
    @Persisted var date: String

    convenience init(name: String, score: Int, date: String) {
        self.init()
        self.name = name
        self.score = score
        self.date = date
    }
}
