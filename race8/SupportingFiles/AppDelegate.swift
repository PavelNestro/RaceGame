//
//  AppDelegate.swift
//  lesson8_HM(race)
//
//  Created by Pavel Nesterenko on 6.03.22.
//

import UIKit
import Firebase
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool {
//                for family in UIFont.familyNames.sorted() {
//                    let names = UIFont.fontNames(forFamilyName: family)
//                    print("Family: \(family) Font names: \(names)")
//                }
        FirebaseApp.configure()
            print(FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask))
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }

}
