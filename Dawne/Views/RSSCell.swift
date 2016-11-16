//
//  RSSCell.swift
//  Dawne
//
//  Created by Chenshuo  Jin on 2016-03-25.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadedFrom(link link:String, contentMode mode: UIViewContentMode) {
        guard
            let url = NSURL(string: link)
            else {return}
        contentMode = mode
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? NSHTTPURLResponse where httpURLResponse.statusCode == 200,
                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let data = data where error == nil,
                let image = UIImage(data: data)
                else { return }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.contentMode = .ScaleAspectFill
                self.image = image
            }
        }).resume()
    }
}

class RSSCell: UITableViewCell {
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    var urlLink: String = ""

    
    func configureCell(imageLink: String, title: String, link: String) {
        self.title.text = title
        self.title.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.title.numberOfLines = 0
        bgImage.downloadedFrom(link: imageLink, contentMode: .ScaleToFill)
        self.urlLink = link
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
