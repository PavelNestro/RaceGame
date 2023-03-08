//
//  User.swift
//  lesson8_HM(race)
//
//  Created by Pavel Nesterenko on 22.07.22.
//

import Foundation
class Settings: Codable {
    static let sheard = Settings()
    var difficult = 1.4
    var nameCar = "pickUp"

    func save(_ user: Settings, _ forKey: UserDefaultsKeys) {
        let arrayData = try? JSONEncoder().encode(user)
        UserDefaults.standard.set(arrayData, forKey: forKey.rawValue)
    }

    func load(_ forkey: UserDefaultsKeys) -> Settings {
        if let encodedData = UserDefaults.standard.value(forKey: forkey.rawValue) as? Data {
            do {
                let arrayUser = try JSONDecoder().decode(Settings.self, from: encodedData )
                return arrayUser
            } catch {
                print(error.localizedDescription)
                return Settings()
            }
        }
        return Settings()
    }
}
