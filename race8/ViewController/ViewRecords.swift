//
//  ViewRecords.swift
//  lesson8_HM(race)
//
//  Created by Pavel Nesterenko on 31.08.22.
//

import UIKit
import RxSwift
import RxCocoa

class ViewRecords: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    static let sheard = ViewRecords()
    let viewModel = TableViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "records".localized.capitalized
        // tableView.dataSource = self
        // tableView.delegate = self
        
        let nib =  UINib(nibName: String(describing: ScoreTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ScoreTableViewCell.identifier)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(addButtonPressed))
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        
        RealmManager.sheard.addPersonsChange {
            self.tableView.reloadData()
        }

        let users = RealmManager.sheard.getUser()
        self.viewModel.dataSource.onNext(users.map({$0}))

        viewModel.dataSource.bind(to: tableView.rx.items(cellIdentifier: ScoreTableViewCell.identifier, cellType: ScoreTableViewCell.self)) { index, model, cell in
            
            cell.configure(with: model)
        }
        .disposed(by: disposeBag)

    }

    @objc func addButtonPressed() {
        try! RealmManager.sheard.realm.write({
            RealmManager.sheard.realm.deleteAll()
        })
    }

    @IBAction func backButton(_ sender: UINavigationItem) {

    }

    
}

//extension ViewRecords: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//guard let cell = tableView.dequeueReusableCell(withIdentifier: ScoreTableViewCell.identifier) as? ScoreTableViewCell else {
//
//            return UITableViewCell()
//        }
//
//        let users = RealmManager.sheard.getUser()[indexPath.row]
//        cell.textLable.text = "User: \(users.name), Score: \(users.score), \(users.date)"
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return RealmManager.sheard.getUser().count
//    }
//}
//
//extension ViewRecords: UITableViewDelegate {
//
//}
