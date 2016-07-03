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
    var allowMultipleGroupsPlaythrough : Bool
    var isCompleted : Bool
    
    
    init( id : Int , name : String  , description : String , creationDate : String , answeredQuestions  :Int ,
        totalQuestions : Int , timeLeftToStart : Int , timeLeftToEnd  : Int , allowMultipleGroups : Bool , isCompleted : Bool){
        self.id = id
        self.name = name
        self.description = description
        self.creationDate = creationDate
        self.totalQuestions = totalQuestions
        self.answeredQuestions = answeredQuestions
        self.timeLeftToStart = timeLeftToStart
        self.timeLeftToEnd = timeLeftToEnd
        self.allowMultipleGroupsPlaythrough = allowMultipleGroups;
        self.isCompleted = isCompleted
    }
}