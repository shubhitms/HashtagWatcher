//
//  FeedTableViewCell.swift
//  HashtagWatcher
//
//  Created by Shubhit Singh on 7/26/15.
//  Copyright (c) 2015 Shubhit Singh. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var feedTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
