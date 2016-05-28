//
//  ApiDriver.swift
//  crowd-gaming
//
//  Created by AMD OS X on 15/05/2016.
//  Copyright © 2016 Stavros Skourtis. All rights reserved.
//

import Foundation
import Darwin

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
    
    static func getDistance(lat1: Double ,lon1: Double , lat2:Double ,lon2:Double ) -> Double{
        let R = 6371.0; // Radius of the earth in km
        let dLat = (lat2 - lat1) * ( M_PI / 180);
        let dLon = (lon2 - lon1) * ( M_PI / 180);
        
        let a =  sin(dLat/2) * sin(dLat / 2) +
            cos(lat1 * (M_PI / 180)) * cos(lat2 * (M_PI / 180)) *
            sin(dLon / 2) * sin(dLon / 2);
        
        let c = 2 * atan2(sqrt(a), sqrt(1 - a));
        let d = R * c; // Distance in km
        return d;
    }
}
