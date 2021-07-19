//
//  FilterViewController.swift
//  Skill Shot
//
//  Created by Will Clarke on 12/21/15.
//
//

import UIKit

class FilterViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var allAgesLabel: UILabel!
    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var allAgesSwitch: UISwitch!
    @IBOutlet weak var sortTextField: UITextField!
    @IBOutlet var keyboardAccessoryView: UIView!
    @IBOutlet var keyboardPickerView: UIPickerView!
    var sortOptions = ["Name", "Distance", "Number of Games"]
    var initialSort = "Name"
    var initialAllAges = false
    var showSortOptions = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortTextField.inputView = self.keyboardPickerView
        sortTextField.inputAccessoryView = self.keyboardAccessoryView
        sortTextField.text = self.initialSort
        allAgesSwitch.isOn = self.initialAllAges
        if showSortOptions {
            sortLabel.isHidden = false
            sortTextField.isHidden = false
        } else {
            sortLabel.isHidden = true
            sortTextField.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func postFilterNotification() {
        var sortField = "Name"
        if let selectedSort = self.sortTextField.text {
            sortField = selectedSort
        }
        let userInfo: [AnyHashable: Any] = ["Sort" : sortField, "AllAges" : allAgesSwitch.isOn]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "FiltersChosen"), object: nil, userInfo: userInfo)
    }
    
    // MARK: - IBActions

    @IBAction func allAgesSwitchFlipped(_ sender: AnyObject) {
        self.postFilterNotification()
    }
    
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        let selectedItem = self.keyboardPickerView.selectedRow(inComponent: 0)
        if selectedItem < self.sortOptions.count {
            sortTextField.text = self.sortOptions[selectedItem]
        }
        self.sortTextField.resignFirstResponder()
        self.postFilterNotification()
    }

    // MARK: - UITextFieldDelegate functions

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let sortText = sortTextField.text {
            if let validIndex = self.sortOptions.firstIndex(of: sortText) {
                self.keyboardPickerView.selectRow(validIndex, inComponent: 0, animated: false)
            }
        }
        return true
    }


    // MARK: - UIPickerViewDataSource functions

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortOptions.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.sortTextField.text = self.sortOptions[row]
        self.postFilterNotification()
    }
}
