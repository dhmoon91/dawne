//
//  WeatherCell.swift
//  Dawne
//
//  Created by Gray Jin on 2016-02-23.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(time: String, temp: String, summary: String) {
        timeLabel.text = time
        tempLabel.text = temp
        summaryLabel.text = summary
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
