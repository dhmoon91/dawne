//
//  RSSControllerTableViewController.swift
//  Dawne
//
//  Created by Chenshuo  Jin on 2016-03-25.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit

class RSSControllerTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet var myTableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var coverScreen: UIImageView!
    
    var rssList :[RssRecord] = [RssRecord]()
    var RSSparser: RSSReader = RSSReader()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.myTableView.rowHeight = 200
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setTable", name: "RSSComplete", object: nil)
        startParser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // return row height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    // return how may records in a table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rssList.count
    }
    
    // return cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("rssCell") as? RSSCell {
            let item = rssList[indexPath.row]
            
            let title = item.title
            let imgLink = item.imgLink
            let link = item.link
            
            cell.configureCell(imgLink, title: title, link: link)
            
            return cell
            
        }
        
        return RSSCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let URL = rssList[indexPath.row].link
        if let checkURL = NSURL(string: URL) {
            if UIApplication.sharedApplication().openURL(checkURL) {
                print("url successfully opened")
            }
        } else {
            print("invalid url")
        }
    }
    
    func startParser() {
        let myURL = NSURL(string: "http://rss.cbc.ca/lineup/topstories.xml")
        RSSparser.startParse(myURL!)
        self.coverScreen.hidden = false
        self.loader.hidden = false
        self.loader.startAnimating()
    }
    
    func setTable() {
        rssList = RSSparser.rssRecordList
        dispatch_async(dispatch_get_main_queue(),{
            self.coverScreen.hidden = true
            self.loader.hidden = true
            self.myTableView.reloadData()
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
