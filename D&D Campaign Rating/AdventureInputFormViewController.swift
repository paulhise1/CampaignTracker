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

class AdventureInputFormViewController: UIViewController, DatePickerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var campaignTitleTextField: UITextField!
    @IBOutlet weak var adventureStoryTextField: UITextField!
    @IBOutlet weak var characterNameTextField: UITextField!
    @IBOutlet weak var characterTypeTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var ratingValueLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var saveLogButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!

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
        createToolBar()
        observeKeyboard()
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

        let adventure = Adventure(campaignTitle: campaignTitleText,
                                  adventureStory: adventureStoryText,
                                  characterName: characterNameText,
                                  characterType: characterTypeText,
                                  note: noteText,
                                  rating: ratingValue,
                                  playDate: date ?? Date(),
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
        noteText = noteTextView.text ?? ""
    }
    
    func configureRatingSlider() {
        ratingSlider.minimumValue = 1
        ratingSlider.maximumValue = 5
        ratingSlider.setValue(ratingValue, animated: false)
        ratingValueLabel.text = String(describing: ratingValue)
    }
    
    func configureFormInputs() {
        campaignTitleTextField.delegate = self
        campaignTitleTextField.text = campaignTitleText
        campaignTitleTextField.returnKeyType = .done
        
        adventureStoryTextField.delegate = self
        adventureStoryTextField.text = adventureStoryText
        adventureStoryTextField.returnKeyType = .done
        
        characterNameTextField.delegate = self
        characterNameTextField.text = characterNameText
        characterNameTextField.returnKeyType = .done
        
        characterTypeTextField.delegate = self
        characterTypeTextField.text = characterTypeText
        characterTypeTextField.returnKeyType = .done
        
        noteTextView.delegate = self
        noteTextView.text = noteText
        noteTextView.returnKeyType = .default
        
        dateLabel.text = date?.getDayAndMonth()
        
        if isEdit {
            saveLogButton.title = "Save Edits"
        } else {
            saveLogButton.title = "Log"
        }
    }

    func observeKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func createToolBar() {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(hideKeyboard))
        
        toolbar.items = [flexButton, doneButton]
        noteTextView.inputAccessoryView = toolbar
    }
    
    @objc func hideKeyboard() {
        noteTextView.resignFirstResponder()
    }
}
