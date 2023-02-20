//
//  GameViewController.swift
//  lesson8_HM(race)
//
//  Created by Pavel Nesterenko on 15.06.22.
//

import UIKit

class GameViewController: UIViewController {
    var point = 0
    let user = User()
    @IBOutlet weak var intLable: UILabel!
    let image = UIImageView()
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var lable: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.setTitle("menu".localized, for: .normal)
        newGameButton.setTitle("new game".localized, for: .normal)
        lable.text = (" score: \(point)")
        self.navigationItem.setHidesBackButton(true, animated: true)

    }

    @IBAction func newGameButtonPressed(_ sender: Any) {
        guard let viewController = ViewControllerFactory.sheard.createStartController() else {
            print("nil")
            return
        }
        navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func muneButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)

        saveArrayStringrecords()
    }

    func rainbow() {
        let text = "Score:"
        let attributedString = NSMutableAttributedString(string: text)
        let colors = [UIColor.red, UIColor.orange, UIColor.purple, UIColor.green, UIColor.blue, UIColor.black]
        for (index, _) in text.enumerated() {
            let color = colors[index]
            attributedString.addAttribute(.foregroundColor, value: color, range: NSRange(location: index, length: 1))
            lable.attributedText = attributedString
            intLable.text = "\(point)"
        }
    }

    func saveArrayStringrecords() {
        var stringRecords = ""
        let user = RealmManager.sheard.getUser()
        guard let userDate = user.last?.date else {
            return
        }
        guard let userName = user.last?.name else {
            return
        }
        guard let userScore = user.last?.score else {
            return
        }
        let score = "score"
        let userNameString = "user"
        stringRecords = "\(userNameString.localized.capitalized): \(userName.localized.capitalized), \(score.localized.capitalized): \(userScore), \(userDate)"
        print(stringRecords)

    }

}
