//
//  DatePickerViewController.swift
//  D&D Campaign Rating
//
//  Created by CJ McCaskill on 1/31/21.
//

import UIKit

protocol DatePickerDelegate: class {
    func dateOfPlaySet(date: Date)
}

class DatePickerViewController: UIViewController {

    weak var delegate: DatePickerDelegate?
    var date: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func configure(date: Date) {
        self.date = date
    }
    
    @IBAction func datePickerValueChange(_ sender: UIDatePicker) {
        date = sender.date
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        delegate?.dateOfPlaySet(date: date ?? Date())
        popAndDismissView()
    }
    @IBAction func cancelTapped(_ sender: Any) {
        popAndDismissView()
    }
    
    func popAndDismissView() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
