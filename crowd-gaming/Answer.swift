//
//  Answer.swift
//  crowd-gaming
//
//  Created by AMD OS X on 29/04/2016.
//  Copyright © 2016 Stavros Skourtis. All rights reserved.
//

import Foundation

class Answer{
    
    var id : Int = 0
    var answerText : String = ""
    var creationDate : String = ""
    
    init ( id : Int , answerText : String , creationDate : String){
        self.id = id
        self.answerText = answerText.stringByReplacingOccurrencesOfString("&quot;", withString: "\"")
        self.answerText = self.answerText.stringByReplacingOccurrencesOfString("&lt;", withString: "<")
        self.answerText = self.answerText.stringByReplacingOccurrencesOfString("&gt;", withString: ">")
        self.answerText = self.answerText.stringByReplacingOccurrencesOfString("&ampt;", withString: "&")
        self.creationDate = creationDate
    }
}