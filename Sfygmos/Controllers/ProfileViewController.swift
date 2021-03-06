//
//  ProfileViewController.swift
//  Sfygmos
//
//  Created by Ian Regino on 4/30/19.
//  Copyright © 2019 iregino. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    //MARK: - Properties
    
    //Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var femaleRadioButton: RadioButton!
    @IBOutlet weak var maleRadioButton: RadioButton!
    @IBOutlet weak var otherRadioButton: RadioButton!
    @IBOutlet weak var bloodTypeTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    //Variables
    private var datePicker: UIDatePicker?
    var user: User?
    
//    override func awakeFromNib() {
//        self.view.layoutIfNeeded()
//        femaleRadioButton.isSelected = false
//        maleRadioButton.isSelected = false
//        otherRadioButton.isSelected = false
//    }
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.layer.cornerRadius = 5.0
        updateSaveButtonState()
        
        femaleRadioButton.isSelected = false
        maleRadioButton.isSelected = false
        otherRadioButton.isSelected = false
        if let savedUser = User.loadUser() {
            user = savedUser //load saved user data from documents directory
            updateUI()
        }
        
        //Create an instance of date picker
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        
        //Create a tap gesture recognizer to dismiss date picker when user tap on the screen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        //Set date of birth text field with date picker value
        dateOfBirthTextField.inputView = datePicker
        
        femaleRadioButton?.alternateButton = [maleRadioButton!, otherRadioButton!]
        maleRadioButton?.alternateButton = [femaleRadioButton!, otherRadioButton!]
        otherRadioButton?.alternateButton = [maleRadioButton!, femaleRadioButton!]
        
    } //end viewDidLoad()
  
    //Update UI with user data
    func updateUI() {
        
        firstNameTextField.text = user?.firstName
        lastNameTextField.text = user?.lastName
        dateOfBirthTextField.text = User.userDateFormatter.string(from: user!.dateOfBirth)
        datePicker?.date = user!.dateOfBirth
        let gender = user?.gender
        switch gender {
        case "M":
            maleRadioButton.isSelected = true
        case "F":
            femaleRadioButton.isSelected = true
        default:
            otherRadioButton.isSelected = true
        }
        bloodTypeTextField.text = user?.bloodType
        emailAddressTextField.text = user?.email
        
    } //end updateUI()
    
    //Dismiss date picker and user tap on screen
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    } //end viewTapped()
    
    //Update date of birth text field with date selected by user
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateOfBirthTextField.text = dateFormatter.string(from: datePicker.date)
    } //end dateChanged()
    
    // When textfield editing is done, update save button state
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    // Update the state of the save button: enable when required textfields are populated
    func updateSaveButtonState() {
        
        // Grab values from text fields to local variables
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let dOB = dateOfBirthTextField.text ?? ""

        // Enable save button if all text fields are not empty
        saveButton.isEnabled = !firstName.isEmpty &&
            !lastName.isEmpty && !dOB.isEmpty
        saveButton.alpha = saveButton.isEnabled ? 1.0 : 0.5
        
    } // end updateSaveButtonState()
    
    //
    @IBAction func saveProfileButtonTapped(_ sender: UIButton) {
        
        //Animate the button when the user taps it
        UIView.animate(withDuration: 0.3) {
            self.saveButton.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
            self.saveButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
    } //end saveProfileButtonTapped()
    

    
    //MARK: - Navigation Methods
    
    //Preparation for navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUserUnwind" else { return }
        
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let dateOfBirth = datePicker?.date
        var gender = ""
        if femaleRadioButton.isSelected {
            gender = "F"
        } else if maleRadioButton.isSelected {
            gender = "M"
        } else if otherRadioButton.isSelected {
            gender = "O"
        }
        let bloodType = bloodTypeTextField.text!
        let email = emailAddressTextField.text!
        
        let newUser = User(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth!, gender: gender, bloodType: bloodType, email: email)
        
        User.saveUser(newUser)
        
    } //end prepare(for segue:)

} //end ProfileViewController{}
