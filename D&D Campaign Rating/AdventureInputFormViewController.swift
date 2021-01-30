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
    var ratingValue: Float = 3 {
        didSet {
            ratingValueLabel.text = String(ratingValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRatingSlider()
    }
    
    @IBAction func ratingSliderDidSlide(_ sender: UISlider) {
        let step: Float = 0.5
        let roundedValue = round(sender.value / step) * step
         sender.value = roundedValue
        ratingValue = sender.value
    }
    
    @IBAction func cancelAndDismissView(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
    
    @IBAction func logAdventure(sender: UIBarButtonItem) {
        recordTextFieldText()
        let adventure = Adventure(campaignTitle: campaignTitleText, adventureStory: adventureStoryText, characterName: characterNameText, characterType: characterTypeText, note: noteText, rating: ratingValue)
        delegate?.logAdventure(adventure: adventure)
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
    }
        
}
