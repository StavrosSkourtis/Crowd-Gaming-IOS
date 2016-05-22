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
    var answeredQuestions : Int
    var totalQuestions : Int
    var timeLeftToStart : Int
    var timeLeftToEnd : Int
    var questionGroups = [QuestionGroup]()
    
    
    init( id qId: Int , name qName : String  , description qDescription : String , creationDate qCreationDate : String , answeredQuestions qAnsweredQuestions :Int ,
        totalQuestion qTotalQuestions: Int , timeLeftToStart qTimeLeftToStart: Int , timeLeftToEnd qTimeLeftToEnd : Int){
        id = qId
        name = qName
        description = qDescription
        creationDate = qCreationDate
        totalQuestions = qTotalQuestions
        answeredQuestions = qAnsweredQuestions
        timeLeftToStart = qTimeLeftToStart
        timeLeftToEnd = qTimeLeftToEnd
    }
}