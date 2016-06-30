//
//  GroupTableViewCell.swift
//  crowd-gaming
//
//  Created by AMD OS X on 24/05/2016.
//  Copyright © 2016 Stavros Skourtis. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var questionGroupName: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var viewOnMapButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var priorityLabel: UILabel!
    
    var viewController : GroupTableViewController?
    var group : QuestionGroup!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Actions
    
    @IBAction func OnViewOnMap(sender: AnyObject) {
        
        viewController!.performSegueWithIdentifier("goToMapViewSegue", sender: self)
        print("Map View")
    }
    
    @IBAction func OnPlay(sender: AnyObject) {
        
        viewController!.performSegueWithIdentifier("playSegue", sender: self)
        print("Play view")
    }
    
    @IBAction func OnReset(sender: AnyObject) {
        
        let confirmAlert = UIAlertController(title: "Reset Question Group", message: "Are you sure you want to reset this question group?", preferredStyle: UIAlertControllerStyle.Alert)
        
        confirmAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            
            
            // create post request
            let url = NSURL(string: ( ApiConfig.apiUrl + "questionnaire/\(self.group.questionnaireId)/group/\(self.group.id)/reset" ) )
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "GET"
            
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
                
                let json = ApiDriver.parseJson(responseString!);
                
                dispatch_sync(dispatch_get_main_queue(),
                {
                    if let code = json["code"] as? String
                    {
                        if code == "200"
                        {
                            self.group.currentRepeats++;
                            self.group.answeredQuestions=0;
                        }
                    }
                    print("Reset: \(json["code"] as? String) / \(json["message"] as? String)" )
                })
                
            }
            task.resume()
            
            
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            
        }))
        
        viewController?.presentViewController(confirmAlert, animated: true, completion: nil)
    }
    

}
