//
//  AdventureCell.swift
//  D&D Campaign Rating
//
//  Created by Paul Hise on 1/29/21.
//

import UIKit

class AdventureCell: UITableViewCell {
    

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var adventureLabel: UILabel!

    func configure(dateText: String, adventure: String) {
        dateLabel.text = dateText
        adventureLabel.text = adventure
    }

}
