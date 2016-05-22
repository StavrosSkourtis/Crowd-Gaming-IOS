//
//  QuestionGroupTableViewController.swift
//  crowd-gaming
//
//  Created by AMD OS X on 22/05/2016.
//  Copyright © 2016 Stavros Skourtis. All rights reserved.
//

import UIKit

class QuestionGroupTableViewController: UITableViewController {
    
    var questionGroups = [QuestionGroup]()
    var questionnaireId : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadQuestionGroups()
    }
    
    func loadQuestionGroups()
    {
        // create post request
        let url = NSURL(string: ( ApiConfig.apiUrl + "questionnaire/\(questionnaireId)/group" ))
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
                    //let allowedRepeats: Int = groupInfo["allowed-repeats"] as! Int
                    //let currentRepeats: Int = groupInfo["current-repeats"] as! Int
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
                    
                    
                    let questionGroup = QuestionGroup(id: id, name: name, latitude: latitude, longitude: longitude, radius: radius, creationDate: creationDate, answeredQuestions: answeredQuestions, currentQuestion: totalQuestions , allowedRepeats: 0 , currentRepeats: 0)
                    
                    print("Question Group \(id)")
                    
                    dispatch_sync(dispatch_get_main_queue(),
                    {
                        self.questionGroups.append(questionGroup)
                    })
                }
            }
            dispatch_sync(dispatch_get_main_queue(),
                {
                    self.loadView()
            })
            
            print("Loading Question Group Completed")
            
            
        }
        task.resume()

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
        return questionGroups.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let callIdentifier = "QuestionGroupTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(callIdentifier, forIndexPath: indexPath) as! QuestionGroupTableViewCell
        
        
        //let questionGroup = questionGroups[indexPath.row]
        
        //cell.questionGroupNameLabel.text = questionGroup.name
        //cell.progressLabel.text = "Progress \(questionGroup.answeredQuestions)/\(questionGroup.totalQuestions)"
        
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}