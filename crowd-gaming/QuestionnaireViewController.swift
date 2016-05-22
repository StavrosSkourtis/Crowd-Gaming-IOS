//
//  QuestionnaireViewController.swift
//  crowd-gaming
//
//  Created by AMD OS X on 22/05/2016.
//  Copyright © 2016 Stavros Skourtis. All rights reserved.
//

import UIKit

class QuestionnaireViewController: UIViewController {
    
    var questionnaire : Questionnaire!
    
    // MARK: Properties
    
    @IBOutlet weak var questionnaireNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int, Int) {
        return ( (seconds/3600)/24 , seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionnaireNameLabel.text = questionnaire.name
        progressLabel.text = "Progress: \(questionnaire.answeredQuestions)/\(questionnaire.totalQuestions)"
        descriptionLabel.text = questionnaire.description
        
        if questionnaire.timeLeftToStart == 0
        {
            let (d,h,m,s) = secondsToHoursMinutesSeconds(questionnaire.timeLeftToEnd)
            statusLabel.text = "Online, Time left \(d) days and \(h):\(m):\(s)"
            statusLabel.textColor = UIColor(red: 5/255.0 , green: 86/255.0 , blue: 9/255.0 , alpha: 1)
        }
        else if questionnaire.timeLeftToStart > 0
        {
            let (d,h,m,s) = secondsToHoursMinutesSeconds(questionnaire.timeLeftToStart)
            statusLabel.text = "Starts in \(d) days and \(h):\(m):\(s)"
        }
        else
        {
            statusLabel.text = "Offline"
            statusLabel.textColor = UIColor(red: 179/255.0 , green: 9/255.0 , blue: 9/255.0 , alpha: 1)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func viewQuestionGroups(sender: AnyObject) {
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let questionGroupTableViewController = segue.destinationViewController as! QuestionGroupTableViewController
        
        questionGroupTableViewController.questionnaireId = questionnaire.id
        
    }
    

}
