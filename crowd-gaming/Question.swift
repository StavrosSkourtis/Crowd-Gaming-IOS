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
    
    init( id  : Int , questionText : String , multiplier : Double , creationDate : String , timeToAnswer : Double){
        self.id = id
        self.questionText = questionText
        self.multiplier = multiplier
        self.creationDate = creationDate
        self.timeToAnswer = timeToAnswer
    }
    
}