//
//  HelpViewCell.swift
//  tutorMe
//
//  Created by Peyt Spencer Dewar on 1/24/16.
//  Copyright © 2016 PSD. All rights reserved.
//

import UIKit

class HelpViewCell: UITableViewCell {
    
    @IBOutlet weak var helpTextLabel: UILabel!
    @IBOutlet weak var helpFirstNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
