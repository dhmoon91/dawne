//
//  TableViewCell.swift
//  Dawne
//
//  Created by Gray Jin on 2016-02-19.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit

class ScheduleViewCell: UITableViewCell {

    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var startToD: UILabel!
    @IBOutlet weak var endToD: UILabel!
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventLocation: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(sTime: String, eTime: String, sTOD: String, eTOD: String, name: String, location: String) {
        self.startTime.text = sTime
        self.endTime.text = eTime
        self.startToD.text = sTOD
        self.endToD.text = eTOD
        self.eventName.text = name
        self.eventLocation.text = location
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
