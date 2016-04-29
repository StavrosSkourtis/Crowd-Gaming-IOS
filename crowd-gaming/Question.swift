//
//  Question.swift
//  crowd-gaming
//
//  Created by AMD OS X on 29/04/2016.
//  Copyright © 2016 Stavros Skourtis. All rights reserved.
//

import Foundation

class Question{
    
    var id : Int = 0
    var questionText : String = ""
    var multiplier: Double = 1
    var creationDate: String = ""
    var timeToAnswer: Double = 5
    var answers = [Answer]()
    
    init( id qId : Int , questionText qQuestionText : String , multiplier qMultiplier : Double , creationDate qCreationDate : String , timeToAnswer qTimeToAnswer : Double){
        id = qId
        questionText = qQuestionText
        multiplier = qMultiplier
        creationDate = qCreationDate
        timeToAnswer = qTimeToAnswer
    }
    
}