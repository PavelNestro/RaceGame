//
//  ScoreTableViewCell.swift
//  race8
//
//  Created by Pavel Nesterenko on 18.09.22.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {

    static let identifier = "ScoreTableViewCell"

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var textLable: UILabel!

    func configure(with model: User) {
        
        self.textLable.text = "User: \(model.name), Score: \(model.score), \(model.date)"
        
    }


}
