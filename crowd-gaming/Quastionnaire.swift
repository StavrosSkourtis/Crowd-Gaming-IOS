//
//  Quastionnaire.swift
//  crowd-gaming
//
//  Created by AMD OS X on 29/04/2016.
//  Copyright © 2016 Stavros Skourtis. All rights reserved.
//

import Foundation


class Questionnaire{
    
    var id : Int
    var name : String
    var description : String
    var creationDate : String
    var questionGroups = [QuestionGroup]()
    
    
    init( id qId: Int , name qName : String  , description qDescription : String , creationDate qCreationDate : String){
        id = qId
        name = qName
        description = qDescription
        creationDate = qCreationDate
    }
}