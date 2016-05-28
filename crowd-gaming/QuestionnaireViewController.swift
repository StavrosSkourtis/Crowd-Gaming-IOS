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
            statusLabel.text = "Time left \(d)d \(h)h \(m)m \(s)s"
            statusLabel.textColor = UIColor(red: 5/255.0 , green: 86/255.0 , blue: 9/255.0 , alpha: 1)
        }
        else if questionnaire.timeLeftToStart > 0
        {
            let (d,h,m,s) = secondsToHoursMinutesSeconds(questionnaire.timeLeftToStart)
            statusLabel.text = "Starts in \(d)d \(h)h \(m)m \(s)s"
        }
        else
        {
            statusLabel.text = "Offline"
            statusLabel.textColor = UIColor(red: 179/255.0 , green: 9/255.0 , blue: 9/255.0 , alpha: 1)
        }
        
        let _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onTimer", userInfo: nil, repeats: true)
        
    }
    
    func onTimer(){
        
        if questionnaire.timeLeftToStart > 0
        {
            questionnaire.timeLeftToStart--;
        }
        else if questionnaire.timeLeftToEnd > 0
        {
            questionnaire.timeLeftToEnd--;
        }
        
        if questionnaire.timeLeftToStart == 0
        {
            let (d,h,m,s) = secondsToHoursMinutesSeconds(questionnaire.timeLeftToEnd)
            statusLabel.text = "Time left \(d)d \(h)h \(m)m \(s)s"
            statusLabel.textColor = UIColor(red: 5/255.0 , green: 86/255.0 , blue: 9/255.0 , alpha: 1)
        }
        else if questionnaire.timeLeftToStart > 0
        {
            let (d,h,m,s) = secondsToHoursMinutesSeconds(questionnaire.timeLeftToStart)
            statusLabel.text = "Starts in \(d)d \(h)h \(m)m \(s)s"
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let groupTableViewController = segue.destinationViewController as! GroupTableViewController
        
        groupTableViewController.questionnaire = questionnaire
        
    }

    

}
