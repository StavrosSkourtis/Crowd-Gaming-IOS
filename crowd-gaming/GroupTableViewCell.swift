//
//  GroupTableViewCell.swift
//  crowd-gaming
//
//  Created by AMD OS X on 24/05/2016.
//  Copyright © 2016 Stavros Skourtis. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var questionGroupName: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var viewOnMapButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var viewController : GroupTableViewController?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Actions
    
    @IBAction func OnViewOnMap(sender: AnyObject) {
        
        viewController!.performSegueWithIdentifier("goToMapViewSegue", sender: self)
        print("Clicked")
    }

}
