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

class AdventureInputFormViewController: UIViewController, DatePickerDelegate {
    
    @IBOutlet weak var campaignTitleTextField: UITextField!
    @IBOutlet weak var adventureStoryTextField: UITextField!
    @IBOutlet weak var characterNameTextField: UITextField!
    @IBOutlet weak var characterTypeTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var ratingValueLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var saveLogButton: UIBarButtonItem!
    
    weak var delegate: InputFormDelegate?
    
    var campaignTitleText: String = ""
    var adventureStoryText: String = ""
    var characterNameText: String = ""
    var characterTypeText: String = ""
    var noteText: String = ""
    var ratingValue: Float = 3
    var date: Date?
    var adventureIdForEdit = ""
    var isEdit = false
    
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
        self.adventureIdForEdit = adventure.adventureId
        self.date = adventure.playDate
        self.isEdit = true
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
    
    @IBAction func logOrEditAdventure(sender: UIBarButtonItem) {
        recordTextFieldText()
        
        var adventureId: String
        if sender.title == "Log"{
            adventureId = String(describing: Date())
        } else {
            adventureId = adventureIdForEdit
        }
        guard let date = self.date else {
            return
        }
        let adventure = Adventure(campaignTitle: campaignTitleText,
                                  adventureStory: adventureStoryText,
                                  characterName: characterNameText,
                                  characterType: characterTypeText,
                                  note: noteText,
                                  rating: ratingValue,
                                  playDate: date,
                                  adventureId: adventureId)
        delegate?.logAdventure(adventure: adventure)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func dateOfPlaySet(date: Date) {
        self.date = date
        self.dateLabel.text = date.getDayAndMonth()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? DatePickerViewController else {
            return
        }
        destinationVC.delegate = self
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
        dateLabel.text = date?.getDayAndMonth()
        
        if isEdit {
            saveLogButton.title = "Save Edits"
        } else {
            saveLogButton.title = "Log"
        }
    }
}
