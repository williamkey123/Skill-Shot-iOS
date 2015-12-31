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
        allAgesSwitch.on = self.initialAllAges
        if showSortOptions {
            sortLabel.hidden = false
            sortTextField.hidden = false
        } else {
            sortLabel.hidden = true
            sortTextField.hidden = true
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        var sortField = "Name"
        if let selectedSort = self.sortTextField.text {
            sortField = selectedSort
        }
        let userInfo: [NSObject : AnyObject] = ["Sort" : sortField, "AllAges" : allAgesSwitch.on]
        NSNotificationCenter.defaultCenter().postNotificationName("FiltersChosen", object: nil, userInfo: userInfo)
    }
    
    // MARK: - IBActions

    @IBAction func allAgesSwitchFlipped(sender: AnyObject) {
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        let selectedItem = self.keyboardPickerView.selectedRowInComponent(0)
        if selectedItem < self.sortOptions.count {
            sortTextField.text = self.sortOptions[selectedItem]
        }
        self.sortTextField.resignFirstResponder()
    }

    // MARK: - UITextFieldDelegate functions

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if let sortText = sortTextField.text {
            if let validIndex = self.sortOptions.indexOf(sortText) {
                self.keyboardPickerView.selectRow(validIndex, inComponent: 0, animated: false)
            }
        }
        return true
    }


    // MARK: - UIPickerViewDataSource functions

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortOptions.count
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortOptions[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.sortTextField.text = self.sortOptions[row]
    }
}
