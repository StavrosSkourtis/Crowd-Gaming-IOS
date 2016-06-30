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
    var name: String
    var questionnaireId: Int
    var latitude : Double?
    var longitude : Double?
    var radius : Double?
    var creationDate : String
    var questions = [Question]()
    
    var answeredQuestions : Int
    var totalQuestions : Int
    
    var allowedRepeats : Int
    var currentRepeats : Int
    
    var priority : Int
    var isCompleted : Bool
    
    var timeToComplete : Int
    var timeLeft : Int?
    
    init ( id : Int , name : String , latitude : Double? , longitude : Double? , radius : Double? , creationDate : String , answeredQuestions : Int , currentQuestion  : Int , allowedRepeats  : Int , currentRepeats : Int , questionnaireId  : Int , priority  : Int , isCompleted  : Bool , timeToComplete : Int , timeLeft : Int? ){
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.creationDate = creationDate
        self.answeredQuestions = answeredQuestions
        self.totalQuestions = currentQuestion
        self.allowedRepeats = allowedRepeats
        self.currentRepeats = currentRepeats
        self.questionnaireId = questionnaireId
        self.priority = priority
        self.isCompleted = isCompleted
        self.timeToComplete = timeToComplete
        self.timeLeft = timeLeft
    }
}