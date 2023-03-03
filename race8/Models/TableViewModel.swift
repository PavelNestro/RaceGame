//
//  TableViewModel.swift
//  race8
//
//  Created by Pavel Nesterenko on 3.03.23.
//

import Foundation
import RxSwift

class TableViewModel {
    var dataSource = BehaviorSubject<[User]>(value: [])
    
}
