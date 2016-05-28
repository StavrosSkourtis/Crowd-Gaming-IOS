//
//  QuestionnaireTableViewController.swift
//  crowd-gaming
//
//  Created by AMD OS X on 22/05/2016.
//  Copyright © 2016 Stavros Skourtis. All rights reserved.
//

import UIKit

class QuestionnaireTableViewController: UITableViewController {

    // MARK: Properties
    
    var questionnaires = [Questionnaire]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onTimer", userInfo: nil, repeats: true)
        
        getQuestionnaires()
    }
    
    func onTimer(){
        
        for questionnaire in questionnaires {
            
            if questionnaire.timeLeftToStart > 0
            {
                questionnaire.timeLeftToStart--;
            }
            else if questionnaire.timeLeftToEnd > 0
            {
                questionnaire.timeLeftToEnd--;
            }
        }
        
        self.tableView.reloadData()
    }
    
    
    func getQuestionnaires()
    {
        
        // create post request
        let url = NSURL(string: ( ApiConfig.apiUrl + "questionnaire" ))
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

            if let questionnairesJsonArray = json["questionnaire"] as? NSArray{
                print("In Here")
                for item in questionnairesJsonArray
                {
                    let questionnaireInfo = item as! NSDictionary
                    
                    let id : Int = questionnaireInfo["id"] as! Int
                    let name : String = questionnaireInfo["name"] as! String
                    let description: String = questionnaireInfo["description"] as! String
                    let creationDate: String = questionnaireInfo["creation-date"] as! String
                    let timeLeft: Int = questionnaireInfo["time-left"] as! Int
                    let timeLeftToEnd: Int = questionnaireInfo["time-left-to-end"] as! Int
                    let totalQuestions: Int = questionnaireInfo["total-questions"] as! Int
                    let answeredQuestions: Int = questionnaireInfo["answered-questions"] as! Int
                    
                    let questionnaire = Questionnaire(id: id, name: name, description: description,creationDate: creationDate , answeredQuestions:  answeredQuestions,totalQuestion: totalQuestions , timeLeftToStart: timeLeft , timeLeftToEnd:  timeLeftToEnd)
                    
                    print("Questionnaire \(id)")
                    
                    dispatch_sync(dispatch_get_main_queue(),
                    {
                        self.questionnaires.append(questionnaire)
                    })
                }
            }
            dispatch_sync(dispatch_get_main_queue(),
            {
                self.tableView.reloadData()
            })
            
            print("Loading Questionnaires Completed")
            
            
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
        return questionnaires.count
    }

    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int, Int) {
        return ( (seconds/3600)/24 , seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let callIdentifier = "QuestionnaireTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(callIdentifier, forIndexPath: indexPath) as! QuestionnaireTableViewCell

        
        let questionnaire = questionnaires[indexPath.row]
        
        cell.nameLabel.text = questionnaire.name
        cell.progressLabel.text = "Progress: \(questionnaire.answeredQuestions)/\(questionnaire.totalQuestions)"
        
        if questionnaire.timeLeftToStart == 0
        {
            let (d,h,m,s) = secondsToHoursMinutesSeconds(questionnaire.timeLeftToEnd)
            cell.statusLabel.text = "Time left \(d)d \(h)h \(m)m \(s)s"
            cell.statusLabel.textColor = UIColor(red: 5/255.0 , green: 86/255.0 , blue: 9/255.0 , alpha: 1)
        }
        else if questionnaire.timeLeftToStart > 0
        {
            let (d,h,m,s) = secondsToHoursMinutesSeconds(questionnaire.timeLeftToStart)
            cell.statusLabel.text = "Starts in \(d)d \(h)h \(m)m \(s)s"
        }
        else
        {
            cell.statusLabel.text = "Offline"
            cell.statusLabel.textColor = UIColor(red: 179/255.0 , green: 9/255.0 , blue: 9/255.0 , alpha: 1)
        }
        print("Loaded")


        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        ///*
        let questionnaireViewController = segue.destinationViewController as! QuestionnaireViewController
        
        if let selectedQuestionnaireCell = sender as? QuestionnaireTableViewCell
        {
            let index = tableView.indexPathForCell(selectedQuestionnaireCell)!
            let selectedQuestionnaire = questionnaires[index.row]
            
            questionnaireViewController.questionnaire = selectedQuestionnaire
        }

        /*
        let questionnaireViewController = segue.destinationViewController as! GroupTableViewController
        
        if let selectedQuestionnaireCell = sender as? QuestionnaireTableViewCell
        {
            let index = tableView.indexPathForCell(selectedQuestionnaireCell)!
            let selectedQuestionnaire = questionnaires[index.row]
            
            questionnaireViewController.questionnaireId = selectedQuestionnaire.id
        }
        */
        
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
    

}
