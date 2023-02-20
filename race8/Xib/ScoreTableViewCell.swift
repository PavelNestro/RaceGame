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
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
