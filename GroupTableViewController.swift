//
//  GroupTableViewController.swift
//  crowd-gaming
//
//  Created by AMD OS X on 24/05/2016.
//  Copyright © 2016 Stavros Skourtis. All rights reserved.
//

import UIKit
import CoreLocation

class GroupTableViewController: UITableViewController,CLLocationManagerDelegate {
    
    
    // MARK: Properties
    
    var groups = [QuestionGroup]()
    var questionnaire : Questionnaire!
    
    var userLatitude: Double?
    var userLongitude: Double?
    var locationManager: CLLocationManager!
    var currentPriority: Int = Int.max ;
    var timerGuard = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if timerGuard {
            locationManager = CLLocationManager()
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            let _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onTimer", userInfo: nil, repeats: true)
            timerGuard = false;
        }
        loadGroups();
    }
    
    func onTimer(){
        
        for group in groups {
            
            if let _ = group.timeLeft where group.timeToComplete != -1 && group.timeLeft >= 0
            {
                group.timeLeft! -= 1
                
                if group.timeLeft! <= 0
                {
                    group.isCompleted = true
                    calculateCurrentPriority()
                }
            }

        }
        
        tableView.reloadData();
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        userLatitude = locValue.latitude
        userLongitude = locValue.longitude
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func loadGroups()
    {
        
        let url = NSURL(string: ( ApiConfig.apiUrl + "questionnaire/\(questionnaire!.id)/group" ))
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        request.setValue("\(ApiConfig.currentUser!.token)", forHTTPHeaderField: "Authorization")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            let json = ApiDriver.parseJson(responseString!)
            print(responseString)
            self.groups.removeAll()
            self.currentPriority = Int.max;
            if let questionGroupsArrayJson = json["question-group"] as? NSArray{
                print("In Here")
                for item in questionGroupsArrayJson
                {
                    
                    let groupInfo = item as! NSDictionary
                    
                    let id : Int = groupInfo["id"] as! Int
                    let name : String = groupInfo["name"] as! String
                    let creationDate: String = groupInfo["creation_date"] as! String
                    let totalQuestions: Int = groupInfo["total-questions"] as! Int
                    let answeredQuestions: Int = groupInfo["answered-questions"] as! Int
                    let allowedRepeats: Int = groupInfo["allowed-repeats"] as! Int
                    let currentRepeats: Int = groupInfo["current-repeats"] as! Int
                    let priority : Int = groupInfo["priority"] as! Int
                    
                    var isCompleted : Int = 0;
                    
                    if let _ = groupInfo["is-completed"] as? Int
                    {
                        isCompleted = groupInfo["is-completed"] as! Int
                    }
                    
                    let timeToComplete : Int = groupInfo["time-to-complete"] as! Int
                    
                    var timeLeft : Int? = nil
                    
                    if let time = groupInfo["time-left"]
                    {
                        timeLeft = time as? Int
                    }
                
                    var latitude: Double? = nil
                    if let lat = groupInfo["latitude"]
                    {
                        latitude = lat as? Double
                    }
                    
                    var longitude: Double? = nil
                    if let long = groupInfo["longitude"]
                    {
                        longitude = long as? Double
                    }
                    
                    var radius: Double? = nil
                    if let rad = groupInfo["radius"]
                    {
                        radius = rad as? Double
                    }
                    
                    print("Question Group \(id)")
                    
                    if isCompleted==0 && priority < self.currentPriority
                    {
                        self.currentPriority = priority;
                    }
                    
                    let questionGroup = QuestionGroup(id: id, name: name, latitude: latitude, longitude: longitude, radius: radius, creationDate: creationDate, answeredQuestions: answeredQuestions, currentQuestion: totalQuestions, allowedRepeats: allowedRepeats, currentRepeats: currentRepeats, questionnaireId: self.questionnaire!.id, priority: priority, isCompleted: isCompleted==1 ? true : false, timeToComplete: timeToComplete, timeLeft: timeLeft)
                    
                    // let questionGroup = QuestionGroup(id: 12, name: "Question group new-name", latitude: 12, longitude: 12, radius: 21, creationDate: "12", answeredQuestions: 1, currentQuestion: 32, allowedRepeats: 4, currentRepeats: 2)
                    
                    dispatch_sync(dispatch_get_main_queue(),
                    {
                        self.groups += [questionGroup]
                    })
                }
            }
            
            print("Loading Question Group Completed")

            
            dispatch_sync(dispatch_get_main_queue(),
            {
                self.tableView.reloadData()
            })
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    func groupTimeLeft (seconds : Int) -> (Int, String) {
        if seconds < 60
        {
            return (seconds , "s" )
        }
        else if seconds < 3600
        {
            return (seconds / 60 , "m")
        }
        return (seconds / 3600 , "h")
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let callIdentifier = "GroupTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(callIdentifier, forIndexPath: indexPath) as! GroupTableViewCell
        
        let group = groups[indexPath.row]
        
        cell.questionGroupName.text = group.name
        
        if group.isCompleted
        {
            cell.progressLabel.text = "Completed Questions: \(group.answeredQuestions)/\(group.totalQuestions)"
            cell.progressLabel.textColor = UIColor(red: 5/255.0 , green: 86/255.0 , blue: 9/255.0 , alpha: 1)
        }
        else
        {
            cell.progressLabel.text = "Questions: \(group.answeredQuestions)/\(group.totalQuestions)"
        }
        
        cell.repeatLabel.text = ""
        cell.group = group;
        cell.playButton.enabled = true;
        cell.resetButton.enabled = true;
        cell.viewOnMapButton.enabled = true;
        
        cell.priorityLabel.text = "Order \(group.priority)  Repeats:\(group.currentRepeats)/\(group.allowedRepeats)"
        
        if group.timeToComplete == -1 || group.isCompleted
        {
            cell.timeLeft.text = ""
        }
        else if let _ = group.timeLeft where group.timeLeft > 0
        {
            let ( value , type) = groupTimeLeft(group.timeLeft!)
            cell.timeLeft.text = "Time Left \(value)\(type)"
        }
        else
        {
            let ( value , type) = groupTimeLeft(group.timeToComplete)
            cell.timeLeft.text = "Available time \(value)\(type)"
        }
        
        if let lat = userLatitude , let lon = userLongitude , let groupLat = group.latitude , let groupLon = group.longitude
        {
            let distance = abs(ApiDriver.getDistance(lat, lon1: lon, lat2: groupLat, lon2: groupLon))
            
            
            if distance * 1000 <= group.radius!
            {
                cell.distanceLabel.text = "On Location"
                cell.distanceLabel.textColor = UIColor(red: 5/255.0 , green: 86/255.0 , blue: 9/255.0 , alpha: 1)
            }
            else
            {
                cell.distanceLabel.text = "\(String(format: "%.2f", abs(distance - (group.radius!/1000))))km away"
                cell.distanceLabel.textColor = UIColor(red: 0 , green: 0 , blue: 0 , alpha: 1)
                cell.playButton.enabled = false
            }
            
        }
        else
        {
            cell.distanceLabel.text = ""
        }
        
        if group.answeredQuestions == group.totalQuestions
        {
            cell.playButton.enabled = false
        }
        
        if questionnaire.timeLeftToStart != 0
        {
            cell.playButton.enabled = false
        }
        
        if group.isCompleted || ( group.priority != currentPriority)
        {
            cell.playButton.enabled = false
        }
        
        if  let _=group.latitude,
            let _=group.longitude,
            let _=group.radius
        {
            if let _ = userLatitude , let _ = userLongitude
            {
                
            }
            else
            {
                cell.distanceLabel.text = "GPS is off"
                cell.distanceLabel.textColor = UIColor(red: 1 , green: 0 , blue: 0 , alpha: 1)
                cell.playButton.enabled = false
            }
            
            cell.viewOnMapButton.enabled = true
        }
        else
        {
            cell.viewOnMapButton.enabled = false
        }
        
        if group.currentRepeats == group.allowedRepeats || group.isCompleted
        {
            cell.resetButton.enabled = false
        }
        
        cell.viewController = self
        
        return cell
    }
    
    func calculateCurrentPriority()
    {
        self.currentPriority = Int.max;
        
        for group in groups {

            if !group.isCompleted && group.priority < self.currentPriority
            {
                self.currentPriority = group.priority;
            }
        }
    }
    
    @IBAction func unwindToQuestionGroupView(unwindSegue: UIStoryboardSegue)
    {
        print("UNWIND!!");
        loadGroups();
    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "goToMapViewSegue"
        {
        
            let mapViewController = segue.destinationViewController as! MapViewController

            if let selectedGroupCell = sender as? GroupTableViewCell
            {
                let index = tableView.indexPathForCell(selectedGroupCell)!
                let selectedGroup = groups[index.row]
            
                mapViewController.group = selectedGroup
                mapViewController.userLat = userLatitude
                mapViewController.userLon = userLongitude
            }
        }
        else if segue.identifier == "playSegue"
        {
            let questionViewController = segue.destinationViewController as! QuestionViewController
            
            if let selectedGroupCell = sender as? GroupTableViewCell
            {
                let index = tableView.indexPathForCell(selectedGroupCell)!
                let selectedGroup = groups[index.row]
                
                questionViewController.group = selectedGroup
                questionViewController.userLatitude = userLatitude
                questionViewController.userLongitude = userLongitude
            }
        }
        

        
    }

}
