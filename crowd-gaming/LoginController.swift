//
//  Login Controller
//  crowd-gaming
//
//  Copyright © 2016 Stavros Skourtis. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onLogin(sender: AnyObject) {

        
        let user = User();
        
        user.email = emailTextField.text!;
        user.password = passwordTextField.text!;

        
        // create post request
        let url = NSURL(string: ( ApiConfig.apiUrl + "authenticate" ))
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        
        let jsonString = "{\"email\":\"" + user.email + "\" ,\"password\":\"" + user.password + "\" }"
        
        // print(jsonString)
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
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
            
            
            if let userJson = json["user"] as? NSDictionary{
                if let name = userJson["name"] as? String {
                    user.name = name;
                }
                
                if let surname = userJson["surname"] as? String{
                    user.surname = surname
                }
                
                if let token = userJson["api-token"] as? String{
                    user.token = token
                }
            }
            
            print("Authentication \(json["code"] as? String) \(json["message"] as? String) ")
            
            dispatch_sync(dispatch_get_main_queue(),
            {
                if json["code"]! as! String == "200"
                {
                    self.errorLabel.text = "Success! Welcome back \(user.name) \(user.surname)."
                    self.errorLabel.textColor = UIColor.greenColor()
                    
                    ApiConfig.currentUser = user
                    
                    self.performSegueWithIdentifier("SegueToQuestionnaireList", sender: self)
                }
                else
                {
                    self.errorLabel.text = "Wrong email or password"
                    self.errorLabel.textColor = UIColor.redColor()
                }
            })
            
        }
        task.resume()
    }
}

