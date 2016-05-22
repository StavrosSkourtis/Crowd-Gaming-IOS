//
//  QuestionGroupTableViewCell.swift
//  crowd-gaming
//
//  Created by AMD OS X on 22/05/2016.
//  Copyright © 2016 Stavros Skourtis. All rights reserved.
//

import UIKit

class QuestionGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var questionGroupNameLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
