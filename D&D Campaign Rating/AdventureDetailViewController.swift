//
//  AdventureDetailViewController.swift
//  D&D Campaign Rating
//
//  Created by CJ McCaskill on 1/29/21.
//

import UIKit

protocol DetailsDelegate: class {
    func updateAdventuresIfNeeded()
}

class AdventureDetailViewController: UIViewController, InputFormDelegate {
    
    weak var delegate: DetailsDelegate?
    
    @IBOutlet weak var campaignTitleLabel: UILabel!
    @IBOutlet weak var datePlayedLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var storyLogLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    var campaignTitle = ""
    var adventureStory = ""
    var rating = ""
    var storyLog = ""
    var character = ""
    var adventure: Adventure?
    var date: Date?
        
    let editFormSegueId = "editForm"
    
    override func viewDidLoad() {
        configureLabels()
    }
    
    func configure(adventure: Adventure) {
        self.adventure = adventure
        self.campaignTitle = adventure.campaignTitle
        self.adventureStory = adventure.adventureStory
        self.rating = String(describing: adventure.rating)
        self.storyLog = adventure.note
        self.character = adventure.characterName + " the " + adventure.characterType
        self.date = adventure.playDate
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
        configure(adventure: adventure)
        configureLabels()
        delegate?.updateAdventuresIfNeeded()
    }
    
    func configureLabels() {
        navBarTitle.title = adventureStory
        campaignTitleLabel.text = campaignTitle
        datePlayedLabel.text = date?.getDayAndMonth()
        ratingLabel.text = rating
        storyLogLabel.text = storyLog
        characterLabel.text = character
    }
}
