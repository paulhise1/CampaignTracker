//
//  AdventureDetailViewController.swift
//  D&D Campaign Rating
//
//  Created by CJ McCaskill on 1/29/21.
//

import UIKit

class AdventureDetailViewController: UIViewController, InputFormDelegate {
    
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
    var adventure: Adventure?
        
    let editFormSegueId = "editForm"
    
    override func viewDidLoad() {
        configureLabels()
        
    }
    
    func configure(adventure: Adventure) {
        self.adventure = adventure
        self.campaignTitle = adventure.campaignTitle
        self.adventureStory = adventure.adventureStory
        self.rating = "Rating: \(adventure.rating)"
        self.storyLog = adventure.note
        self.character = adventure.characterName + " the " + adventure.characterType
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
    
    @IBAction func editTapped(_ sender: Any) {
        performSegue(withIdentifier: editFormSegueId, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? AdventureInputFormViewController else {
            return
        }
        guard let adventureToEdit = self.adventure else {
            return
        }
        destinationVC.delegate = self
        destinationVC.configureForEdit(adventure: adventureToEdit)
    }
    
    func logAdventure(adventure: Adventure) {
        AdventureStore().editAdventure(adventure: adventure)
    }
    
    func configureLabels() {
        campaignTitleLabel.text = campaignTitle
        adventureStoryLabel.text = adventureStory
        ratingLabel.text = rating
        storyLogLabel.text = storyLog
        characterLabel.text = character
    }
}
