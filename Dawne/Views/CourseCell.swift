//
//  CourseCell.swift
//  Dawne
//
//  Created by Gray Jin on 2016-02-21.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit

class CourseCell: UITableViewCell {
        
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var section: UILabel!
    @IBOutlet weak var days: UILabel!
    @IBOutlet weak var courseTime: UILabel!
    @IBOutlet weak var location: UILabel!
    
    var index: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(courseName: String, courseCode: String, section: String, days: String, sTime: String, eTime: String, location: String, index:Int) {
        self.courseName.text = "\(courseName) \(courseCode)"
        self.section.text = section
        self.days.text = days
        self.courseTime.text = "\(sTime) - \(eTime)"
        self.location.text = location
        self.index = index
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

class SearchCell: CourseCell {
    @IBOutlet weak var selectSwitch: UISwitch!
}

class ListCell: CourseCell {
    @IBAction func deleteCourse(sender: UIButton) {
        print("Deleting \(self.index)")
    }
    
}
