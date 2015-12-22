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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func allAgesSwitchFlipped(sender: AnyObject) {
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
    }

    // MARK: - UITextFieldDelegate functions

    


    // MARK: - UIPickerViewDataSource functions

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
}
