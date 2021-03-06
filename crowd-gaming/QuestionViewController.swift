//
//  QuestionViewController.swift
//  crowd-gaming
//
//  Created by AMD OS X on 26/05/2016.
//  Copyright © 2016 Stavros Skourtis. All rights reserved.
//

import UIKit
import CoreLocation

class QuestionViewController: UIViewController ,CLLocationManagerDelegate{

    // MARK: Properties
    var group : QuestionGroup?
    var question: Question?
    var answers = [Answer]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    
    
    var userLatitude : Double?;
    var userLongitude : Double?;
    
    var answerChoise : Int = 0;
    var locationManager :CLLocationManager!
    var buttonIsConfirm = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        answerButton1.layer.cornerRadius = 12
        answerButton1.titleLabel?.numberOfLines = 0
        answerButton1.titleLabel?.adjustsFontSizeToFitWidth = true
        answerButton1.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        answerButton2.layer.cornerRadius = 12
        answerButton2.titleLabel?.numberOfLines = 0
        answerButton2.titleLabel?.adjustsFontSizeToFitWidth = true
        answerButton2.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        answerButton3.layer.cornerRadius = 12
        answerButton3.titleLabel?.numberOfLines = 0
        answerButton3.titleLabel?.adjustsFontSizeToFitWidth = true
        answerButton3.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
    
        answerButton4.layer.cornerRadius = 12
        answerButton4.titleLabel?.numberOfLines = 0
        answerButton4.titleLabel?.adjustsFontSizeToFitWidth = true
        answerButton4.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        
        
        let _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onTimer", userInfo: nil, repeats: true)
        
        loadNextQuestion()
    }
    
    func onTimer()
    {
        if let _ = question {
            if( buttonIsConfirm )
            {
                print(" TTA : \(question?.timeToAnswer)")
                

                if question?.timeToAnswer <= -1
                {
                    statusLabel.text = "Select an answer";
                }
                else if( question?.timeToAnswer == 0 )
                {
                    postAnswer(0);
                }
                else
                {
                    statusLabel.text = String(format: "Time left: %.0fs", question!.timeToAnswer)
                    question!.timeToAnswer--;
                }
                
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        userLatitude = locValue.latitude
        userLongitude = locValue.longitude
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadNextQuestion()
    {
        answers.removeAll()
        let url = NSURL(string: ( ApiConfig.apiUrl + "questionnaire/\(group!.questionnaireId)/group/\(group!.id)/question" ))
        print(ApiConfig.apiUrl + "questionnaire/\(group!.questionnaireId)/group/\(group!.id)/question" )
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        
        request.setValue("\(ApiConfig.currentUser!.token)", forHTTPHeaderField: "Authorization")
        
        if  let _=group!.latitude,
            let _=group!.longitude,
            let _=group!.radius
        {
            request.setValue("\(userLatitude!);\(userLongitude!)", forHTTPHeaderField: "X-Coordinates")
        }
        
        
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
            
            if let code = json["code"] as? String
            {
                
                dispatch_sync(dispatch_get_main_queue(),
                {
                    switch code{
                    
                    case "200":
                        
                        self.group?.timeLeft = self.group!.timeToComplete
                        print ("Loading Question")
                        /*
                            Load Question
                        */
                    
                        if let questionJson = json["question"] as? NSDictionary
                        {
                            let id = questionJson["id"] as! Int
                            let questionText = questionJson["question-text"] as! String
                            let multiplier = questionJson["multiplier"] as! Double
                            let creationDate = questionJson["creation_date"] as! String
                            let timeToAnswer = questionJson["time-to-answer"] as! Double
                        
                            let question = Question(id: id, questionText: questionText, multiplier: multiplier, creationDate: creationDate, timeToAnswer: timeToAnswer)
                        
                       
                            self.question = question
                        
                        
                        }
                    
                        print ("Loading Answers")
                        /*
                            Load Answers
                        */
                        if let answerJson = json["answer"] as? NSArray{
                            print("In Here")
                            for item in answerJson
                            {
                                let answerInfo = item as! NSDictionary
                                
                                let id : Int = answerInfo["id"] as! Int
                                let answerText : String = answerInfo["answer-text"] as! String
                                let creationDate: String = answerInfo["creation_date"] as! String
                            
                                let answer = Answer(id: id, answerText: answerText, creationDate: creationDate)
                            
                                print("Questionnaire \(id)")
                            
                               // dispatch_sync(dispatch_get_main_queue(),
                                
                                    self.answers.append(answer)
                               //})
                            }
                        }
                    
                    //dispatch_sync(dispatch_get_main_queue() , {
                        self.titleLabel.text = "\(self.group!.name) \(self.group!.answeredQuestions+1)/\(self.group!.totalQuestions)"
                        self.questionLabel.text = self.question!.questionText
                        
                        self.answerButton1.setTitle( self.answers[0].answerText, forState: .Normal)
                        self.answerButton1.backgroundColor = UIColor(red: 77/255.0, green: 195/255.0, blue: 1, alpha: 1)
                        self.answerButton2.setTitle( self.answers[1].answerText, forState: .Normal)
                        self.answerButton2.backgroundColor = UIColor(red: 77/255.0, green: 195/255.0, blue: 1, alpha: 1)
                        
                        if self.answers.count >= 3 {
                            self.answerButton3.setTitle( self.answers[2].answerText, forState: .Normal)
                            self.answerButton3.backgroundColor = UIColor(red: 77/255.0, green: 195/255.0, blue: 1, alpha: 1)
                            self.answerButton3.enabled = true
                        }
                        else{
                            self.answerButton3.setTitle( "", forState: .Normal)
                            self.answerButton3.enabled = false
                            self.answerButton3.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0)
                        }
                        
                        if self.answers.count >= 4 {
                            self.answerButton4.setTitle( self.answers[3].answerText, forState: .Normal)
                            self.answerButton4.backgroundColor = UIColor(red: 77/255.0, green: 195/255.0, blue: 1, alpha: 1)
                            self.answerButton4.enabled = true
                        }else{
                            self.answerButton4.setTitle( "", forState: .Normal)
                            self.answerButton4.enabled = false;
                            self.answerButton4.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0)
                        }
                        
                        if self.question?.timeToAnswer <= -1
                        {
                            self.statusLabel.text = "Select an answer";
                        }
                        else
                        {
                            self.statusLabel.text = String(format: "Time left: %.0fs", self.question!.timeToAnswer)
                        }
                        
                        self.buttonIsConfirm = true;
                        self.actionButton.setTitle("Confirm", forState: .Normal)
                   // })
                    
                    default:
                        let alert = UIAlertController(title: "Error", message: json["message"] as? String, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) in
                            print("Back to group list")
                            self.performSegueWithIdentifier("goBackToGroupsSegue", sender: self)
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                        break
                    }
                })
            }
            else
            {
                print("Code is nil")
                self.performSegueWithIdentifier("goBackToGroupsSegue", sender: self)
            }
            
            dispatch_sync(dispatch_get_main_queue(),
            {
                  //  self.loadView()
            })
            
        }
        task.resume()

        
    }
    
    
    func postAnswer( answerChoice : Int ){
        
        if( answers.count == 0 ){
            return;
        }
        
     
        // create post request
        let url = NSURL(string: ( ApiConfig.apiUrl + "answer" ))
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        var jsonString = ""
        
        if answerChoice != 0
        {
            jsonString = "{\"question-id\":\"\(question!.id)\" ,\"answer-id\":\"\(answers[answerChoice-1].id)\" ,\"time-answered\":\"42\" }"
        }
        else
        {
            jsonString = "{\"question-id\":\"\(question!.id)\" ,\"answer-id\":\"null\" ,\"time-answered\":\"42\" }"
        }
 
        print("I'm sending this shit to the server \"\(jsonString)\"")
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.setValue("\(ApiConfig.currentUser!.token)", forHTTPHeaderField: "Authorization")
        
        if  let _=group!.latitude,
            let _=group!.longitude,
            let _=group!.radius
        {
            request.setValue("\(userLatitude!);\(userLongitude!)", forHTTPHeaderField: "X-Coordinates")
        }
        
        
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
            
            print(responseString)
            dispatch_sync(dispatch_get_main_queue(),
            {
                if let code = json["code"] as? String
                {
                    switch code{
                    
                    case "200","201":
                        print ("200")
                        if self.answerChoise == 0 {
                            self.statusLabel.text = "Time run out!"
                        }else{
                            self.statusLabel.text = "Answer was posted."
                        }
                        self.group?.answeredQuestions += 1
                        
                        if code == "201"
                        {
                            self.group?.isCompleted = true
                            
                            self.performSegueWithIdentifier("goBackToGroupsSegue", sender: self)
                        }
                        
                    case "603" , "605" , "606" , "607" , "500" , "610":
                        let alert = UIAlertController(title: "Attention!", message: json["message"] as! String, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                            switch action.style{
                            case .Default , .Cancel , .Destructive:
                                self.performSegueWithIdentifier("goBackToGroupsSegue", sender: self)
                            }
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    default:
                        print ("No code mate")
                        break
                    }
                    self.buttonIsConfirm = false
                    self.actionButton.setTitle("Next Question", forState: .Normal)
                    //self.loadNextQuestion()
                }
                else
                {
                    print("Code is nil")
                }
                
                if answerChoice != 1
                {
                    self.answerButton1.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
                }
                
                if answerChoice != 2
                {
                    self.answerButton2.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
                }
                
                if self.answers.count >= 3 && answerChoice != 3
                {
                    self.answerButton3.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
                }
                
                if self.answers.count == 4 && answerChoice != 4
                {
                    self.answerButton4.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
                }
            })

        }
        task.resume()
    }
    
    
    // MARK: Actions
    
    
    @IBAction func OnAction(sender: AnyObject) {
        
        if buttonIsConfirm && answerChoise != 0
        {
            postAnswer(answerChoise)
        }
        else if buttonIsConfirm && answerChoise == 0
        {
            // nothing for now
        }
        else
        {
            loadNextQuestion();
        }
        
    }
    
    @IBAction func OnAnswer1(sender: AnyObject) {
        
        if !buttonIsConfirm
        {
            return;
        }
        
        answerChoise = 1;
        
        answerButton1.backgroundColor = UIColor(red: 204/255.0, green: 235/255.0, blue: 1, alpha: 1)
        answerButton2.backgroundColor = UIColor(red: 77/255.0, green: 195/255.0, blue: 1, alpha: 1)
        if( answers.count >= 3 )
        {
            answerButton3.backgroundColor = UIColor(red: 77/255.0, green: 195/255.0, blue: 1, alpha: 1)
        }
        if( answers.count == 4)
        {
            answerButton4.backgroundColor = UIColor(red: 77/255.0, green: 195/255.0, blue: 1, alpha: 1)
        }
    }
    
    @IBAction func unwindFromApiResponse(unwindSegue: UIStoryboardSegue)
    {
        
    }
    
    @IBAction func OnAnswer2(sender: AnyObject) {
        
        if !buttonIsConfirm
        {
            return;
        }
        
        answerChoise = 2
        
        answerButton2.backgroundColor = UIColor(red: 204/255.0, green: 235/255.0, blue: 1, alpha: 1)
        answerButton1.backgroundColor = UIColor(red: 77/255.0, green: 195/255.0, blue: 1, alpha: 1)
        if( answers.count >= 3 )
        {
            answerButton3.backgroundColor = UIColor(red: 77/255.0, green: 195/255.0, blue: 1, alpha: 1)
        }
        if( answers.count == 4)
        {
            answerButton4.backgroundColor = UIColor(red: 77/255.0, green: 195/255.0, blue: 1, alpha: 1)
        }
    }
    
    @IBAction func OnAnswer3(sender: AnyObject) {
        
        if !buttonIsConfirm
        {
            return;
        }
        
        if answers.count >= 3
        {
            answerChoise = 3;
            answerButton1.backgroundColor = UIColor(red: 77/255.0, green: 195/255.0, blue: 1, alpha: 1)
            answerButton2.backgroundColor = UIColor(red: 77/255.0, green: 195/255.0, blue: 1, alpha: 1)
            answerButton3.backgroundColor = UIColor(red: 204/255.0, green: 235/255.0, blue: 1, alpha: 1)
            if( answers.count == 4 )
            {
                answerButton4.backgroundColor = UIColor(red: 77/255.0, green: 195/255.0, blue: 1, alpha: 1)
            }
        }
    }
    
    @IBAction func OnAction4(sender: AnyObject) {
        if !buttonIsConfirm
        {
            return;
        }
        
        if answers.count == 4
        {
            answerChoise = 4
            answerButton1.backgroundColor = UIColor(red: 77/255.0, green: 195/255.0, blue: 1, alpha: 1)
            answerButton2.backgroundColor = UIColor(red: 77/255.0, green: 195/255.0, blue: 1, alpha: 1)
            answerButton3.backgroundColor = UIColor(red: 77/255.0, green: 195/255.0, blue: 1, alpha: 1)
            answerButton4.backgroundColor = UIColor(red: 204/255.0, green: 238/255.0, blue: 1, alpha: 1)
            
        }
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
