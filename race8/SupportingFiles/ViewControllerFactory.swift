//
//  ViewControllerFactory.swift
//  lesson8_HM(race)
//
//  Created by Pavel Nesterenko on 6.03.22.
//

import Foundation
import UIKit
class ViewControllerFactory {

   static let sheard = ViewControllerFactory()
   private let storyboard = UIStoryboard(name: "Main", bundle: nil)

   private init() {}

    func createStartController() -> ViewStart? {
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewStart") as? ViewStart
        return viewController
    }

    func createOptionsController() -> ViewOptions {
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ViewOptions")
                as? ViewOptions else {
            return ViewOptions()
        }
        return viewController
    }

    func createRecordsController() -> ViewRecords {
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ViewRecords")
                as? ViewRecords else {
            return ViewRecords()
        }

        return viewController
    }

    func createGameOwerViewController() -> GameViewController {
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "GameViewController")
                as? GameViewController else {
            return GameViewController()
        }
        return viewController
    }

    func createViewController() -> ViewController {
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
                as? ViewController else {
            return ViewController()
        }
        return viewController
    }
    
    func createChooseCarViewController() -> ChooseCarViewController {
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ChooseCarViewController")
                as? ChooseCarViewController else {
            return ChooseCarViewController()
        }
        return viewController
    }

}
