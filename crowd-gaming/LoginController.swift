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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onLogin(sender: AnyObject) {
        print( emailTextField.text )
        print(passwordTextField.text )
        
        
        
        // create post request
        let url = NSURL(string: ( ApiConfig.apiUrl + "authenticate" ))
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        

        let jsonString = "{\"email\":\"" + emailTextField.text! + "\" ,\"password\":\"" + passwordTextField.text! + "\" }"
        print(jsonString)
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
}

