//
//  AdventureDetailViewController.swift
//  D&D Campaign Rating
//
//  Created by CJ McCaskill on 1/29/21.
//

import UIKit

class AdventureDetailViewController: UIViewController {
    
    @IBOutlet weak var campaignTitleLabel: UILabel!
    @IBOutlet weak var adventureStoryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var storyLogLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    
    var campaignTitle = ""
    var adventureStory = ""
    var rating = ""
    var storyLog = ""
    var character = ""
    
    override func viewDidLoad() {
        campaignTitleLabel.text = campaignTitle
        adventureStoryLabel.text = adventureStory
        ratingLabel.text = rating
        storyLogLabel.text = storyLog
        characterLabel.text = character
    }
    
    func configure(campaignTitle: String,
                   adventureStory: String,
                   rating: String,
                   storyLog: String,
                   character: String) {
        self.campaignTitle = campaignTitle
        self.adventureStory = adventureStory
        self.rating = rating
        self.storyLog = storyLog
        self.character = character
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
    
    @IBAction func editTapped(_ sender: Any) {
        
    }
    
    
}
