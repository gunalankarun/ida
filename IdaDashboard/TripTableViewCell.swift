//
//  TripTableViewCell.swift
//  IdaDashboard
//
//  Created by Kevin Tai on 2/5/18.
//  Copyright © 2018 Ida. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var tripLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mpgLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
