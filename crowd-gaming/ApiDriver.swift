//
//  ApiDriver.swift
//  crowd-gaming
//
//  Created by AMD OS X on 15/05/2016.
//  Copyright © 2016 Stavros Skourtis. All rights reserved.
//

import Foundation


class ApiDriver{
    
    static func parseJson(src: NSString ) -> NSDictionary {
        
        let data = src.dataUsingEncoding(NSUTF8StringEncoding)
        var error : NSError?
        
        let anyObj: AnyObject?
        
        do{
            anyObj = try NSJSONSerialization.JSONObjectWithData( data! , options: NSJSONReadingOptions(rawValue: 0))
        } catch let error1 as NSError {
            error = error1
            anyObj = nil
        }
        
        if( error != nil){
            return NSDictionary();
        }else{
            return anyObj as! NSDictionary;
        }
        
    }
    
    
}
