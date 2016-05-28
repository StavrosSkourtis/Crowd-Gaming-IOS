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
    
    init ( id qId : Int , name qName : String , latitude qLatitude : Double? , longitude qLongitude : Double? , radius qRadius : Double? , creationDate qCreationDate : String , answeredQuestions qAnsweredQuestions : Int , currentQuestion qCurrentQuestions : Int , allowedRepeats qAllowedRepeats : Int , currentRepeats qCurrentRepeats: Int , questionnaireId qQuestionnaireId : Int){
        id = qId
        name = qName
        latitude = qLatitude
        longitude = qLongitude
        radius = qRadius
        creationDate = qCreationDate
        answeredQuestions = qAnsweredQuestions
        totalQuestions = qCurrentQuestions
        allowedRepeats = qAllowedRepeats
        currentRepeats = qCurrentRepeats
        questionnaireId = qQuestionnaireId
    }
}