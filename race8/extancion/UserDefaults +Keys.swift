//
//  UserDefaults +Keys.swift
//  lesson8_HM(race)
//
//  Created by Pavel Nesterenko on 14.07.22.
//

import Foundation
extension UserDefaults {
     func setValue(_ value: Any?, forKey key: UserDefaultsKeys) { // <--- сохранять значение
         self.setValue(value, forKey: key.rawValue)
    }
     func value(forKey key: UserDefaultsKeys) -> Any? { // <---- доставать значение 
         return self.value(forKey: key.rawValue)
    }
    // После этого мы можем использовать вместо этого выражения
    // self.userDefaults.set(count, forKey: UserDefaultsKeys.currentCount.rawValue)
    // вот так
   // self.userDefaults.setValue(count, forKey: .currentCount)
    // rowValue - это строчное значение нашего Enum которое показывает наши строки "User_count_value"
}
