//
//  WeatherController.swift
//  Dawne
//
//  Created by Gray Jin on 2016-02-23.
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import UIKit

class WeatherController: UITableViewController {
    
    let MODEL = Model.sharedInstance
    
    var weatherList = [WeatherInfo]()

    @IBOutlet weak var curTemp: UILabel!
    @IBOutlet weak var windChill: UILabel!
    @IBOutlet weak var weatherSummary: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var humidity: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MODEL.searchWeather()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getWeather", name: "weatherReady", object: nil)
        getWeather()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weatherList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        if let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell") as? WeatherCell {
            let weather = self.weatherList[indexPath.row]
            let time = weather.time
            let temperature = weather.curTemp
            let summary = weather.summary
            
            cell.configureCell(time, temp: temperature, summary: summary)
            
            return cell
        } else {
            return WeatherCell()
        }
        
    }
    
    func getWeather() {
        dispatch_async(dispatch_get_main_queue(),{
            let curWeather = self.MODEL.currentTemp
            self.curTemp.text = curWeather.curTemp
            self.weatherSummary.text = curWeather.summary
            self.windChill.text = curWeather.feelsLike
            self.minTemp.text = curWeather.low
            self.maxTemp.text = curWeather.high
            self.humidity.text = curWeather.humidity
            
            self.weatherList = self.MODEL.tempForDay
            
            self.tableView.reloadData()
        })
    }
    
    func getRound(num: float_t) -> Int {
        return Int(round(num))
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
