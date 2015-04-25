//
//  DetailTableViewCell.swift
//  BlogPost
//
//  Created by Andela Developer on 4/19/15.
//  Copyright (c) 2015 Andela. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var fieldLabel: UILabel!

}
