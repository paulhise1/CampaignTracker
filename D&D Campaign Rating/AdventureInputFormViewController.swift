//
//  AdventureInputFormViewController.swift
//  D&D Campaign Rating
//
//  Created by CJ McCaskill on 1/25/21.
//

import UIKit


protocol InputFormDelegate: class {
    func logAdventure(adventure: Adventure)
}

class AdventureInputFormViewController: UIViewController {

    
    @IBOutlet weak var campaignTitleTextField: UITextField!
    @IBOutlet weak var adventureStoryTextField: UITextField!
    @IBOutlet weak var characterNameTextField: UITextField!
    @IBOutlet weak var characterTypeTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var ratingValueLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    weak var delegate: InputFormDelegate?
    
    var campaignTitleText: String = ""
    var adventureStoryText: String = ""
    var characterNameText: String = ""
    var characterTypeText: String = ""
    var noteText: String = ""
    var ratingValue: Float = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRatingSlider()
        configureFormInputs()
    }
    
    func configureForEdit(adventure: Adventure) {
        self.campaignTitleText = adventure.campaignTitle
        self.adventureStoryText = adventure.adventureStory
        self.characterNameText = adventure.characterName
        self.characterTypeText = adventure.characterType
        self.noteText = adventure.note
        self.ratingValue = adventure.rating
    }
    
    @IBAction func ratingSliderDidSlide(_ sender: UISlider) {
        let step: Float = 0.5
        let roundedValue = round(sender.value / step) * step
         sender.value = roundedValue
        ratingValue = sender.value
        ratingValueLabel.text = String(describing: ratingValue)
    }
    
    @IBAction func cancelAndDismissView(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
    
    @IBAction func logAdventure(sender: UIBarButtonItem) {
        recordTextFieldText()
        let format = "EEEE, MMM d, yyyy"
        let date = Date()
        let dateText = date.getFormattedDate(format: format)
        let adventure = Adventure(campaignTitle: campaignTitleText,
                                  adventureStory: adventureStoryText,
                                  characterName: characterNameText,
                                  characterType: characterTypeText,
                                  note: noteText,
                                  rating: ratingValue,
                                  playDateText: dateText,
                                  adventureID: String(describing: date))
        delegate?.logAdventure(adventure: adventure)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func recordTextFieldText() {
        campaignTitleText = campaignTitleTextField.text  ?? ""
        adventureStoryText = adventureStoryTextField.text ?? ""
        characterNameText = characterNameTextField.text ?? ""
        characterTypeText = characterTypeTextField.text ?? ""
        noteText = noteTextField.text ?? ""
    }
    
    func configureRatingSlider() {
        ratingSlider.minimumValue = 1
        ratingSlider.maximumValue = 5
        ratingSlider.setValue(ratingValue, animated: false)
        ratingValueLabel.text = String(describing: ratingValue)
    }
    
    func configureFormInputs() {
        campaignTitleTextField.text = campaignTitleText
        adventureStoryTextField.text = adventureStoryText
        characterNameTextField.text = characterNameText
        characterTypeTextField.text = characterTypeText
        noteTextField.text = noteText
    }
}
