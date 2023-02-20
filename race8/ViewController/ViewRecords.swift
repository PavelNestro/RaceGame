//
//  ViewRecords.swift
//  lesson8_HM(race)
//
//  Created by Pavel Nesterenko on 31.08.22.
//

import UIKit

class ViewRecords: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    static let sheard = ViewRecords()
    var userArray: [String] = []
    static var userArrayStringTwo: [String] = []
    var userObject = [Settings]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "records".localized.capitalized
        tableView.dataSource = self
        tableView.delegate = self
        userArray = loadArrayString()

        let nib =  UINib(nibName: String(describing: ScoreTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ScoreTableViewCell.identifier)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(addButtonPressed))
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        RealmManager.sheard.addPersonsChange {
            self.tableView.reloadData()
        }

}
    @objc func addButtonPressed() {
        try! RealmManager.sheard.realm.write({
            RealmManager.sheard.realm.deleteAll()
        })
    }

    @IBAction func backButton(_ sender: UINavigationItem) {

    }
    func saveArrayString(_ array: [String]) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(array, forKey: "array_string")

    }

    func loadArrayString() -> [String] {
        var arrayString: [String]
        let userDefaults = UserDefaults.standard
        guard let lastValue = userDefaults.stringArray(forKey: "array_string") else {
            return [String]()
        }

        arrayString = lastValue
        return arrayString
    }
    
}

extension ViewRecords: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
guard let cell = tableView.dequeueReusableCell(withIdentifier:
                                                ScoreTableViewCell.identifier) as? ScoreTableViewCell else {
            return UITableViewCell()
        }
        let users = RealmManager.sheard.getUser()[indexPath.row]
        cell.textLable.text = "User: \(users.name), Score: \(users.score), \(users.date)"
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RealmManager.sheard.getUser().count
    }
}
extension ViewRecords: UITableViewDelegate {

}
