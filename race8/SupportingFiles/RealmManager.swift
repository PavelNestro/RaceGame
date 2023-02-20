//
//  File.swift
//  race8
//
//  Created by Pavel Nesterenko on 15.02.23.
//

import Foundation
import RealmSwift

class RealmManager {
    static let sheard = RealmManager()
     let realm: Realm!
    private var observationTokens = [NotificationToken]()
    private init() {
        do {
            self.realm = try Realm()
        } catch {
            print(error.localizedDescription)
            fatalError()
        }
    }
    func setUser(_ user: User) {
        do {
            try realm.write {

                realm.add(user)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    func getUser(moreThen point: Int? = nil ) -> Results<User> {
        let users = realm.objects(User.self)
        if let point = point {
            return users.filter("Age > \(point)")
        } else {
            return users
        }
    }
    func addPersonsChange(handler: @escaping () -> ()) {
        let observationToken = getUser().observe { _ in
            handler()
        }
        observationTokens.append(observationToken)
    }
}

