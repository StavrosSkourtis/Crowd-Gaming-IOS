//
//  QuestionGroup.swift
//  crowd-gaming
//
//  Created by AMD OS X on 29/04/2016.
//  Copyright © 2016 Stavros Skourtis. All rights reserved.
//

import Foundation

class QuestionGroup{
    
    var id : Int
    var latitude : Double
    var longitude : Double
    var radius : Double
    var creationDate : String
    var questions = [Question]()
    
    init ( id qId : Int , latitude qLatitude : Double , longitude qLongitude : Double , radius qRadius : Double , creationDate qCreationDate : String){
        id = qId
        latitude = qLatitude
        longitude = qLongitude
        radius = qRadius
        creationDate = qCreationDate
    }
}