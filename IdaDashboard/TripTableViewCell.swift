//
//  TripTableViewCell.swift
//  IdaDashboard
//
//  Created by Kevin Tai on 2/5/18.
//  Copyright © 2018 Ida. All rights reserved.
//

import UIKit
import UICircularProgressRing

class TripTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var tripLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var mpgLabel: UILabel!
    @IBOutlet weak var scoreRing: UICircularProgressRingView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
