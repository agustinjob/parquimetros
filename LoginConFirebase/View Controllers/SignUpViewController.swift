//
//  SignUpViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 23/12/19.
//  Copyright © 2019 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit
//import FirebaseAuth

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()

    }
    
    func setUpElements(){
        errorLabel.alpha = 0
        Utilities.styleTextField(firstNameTextField, txt: "Nombre")
        Utilities.styleTextField(lastNameTextField,txt: "Apellidos")
        Utilities.styleTextField(emailTextField, txt: "Email")
        Utilities.styleTextField(passwordTextField,txt: "Contraseña")
        Utilities.styleFilledButton(signUpButton)
    }
    //Check the fields and validate that the data is correct. If everithing is correct, this method returns nil. Otherwise, it returns the error message
    
    func validateFileds() -> String?{
        // Check that all the fields are fillen in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill all the fields."
        }
        
        // check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Return isn't secure enougth
            return "Please make sure your password is at least 8 characters, contains a special character and a number"
        }
        
        return nil
    }
    
    @IBAction func signUpTap(_ sender: Any) {
    /*
       
        let error = validateFileds()
        if error != nil {
            // There is something wrong with the fields, show error message
            showError(error!)
        }
        else{
            // Create cleaned version of the data
            let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (results, err) in
                // check for errors
                if err != nil {
                    // Ther was an error creating the user
                    self.showError("Error creating user")
                }else{
                    // User was created succesfully, now store the first name and lasta name
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data:["firstname":firstname, "lastaname":lastname, "uid": results!.user.uid]) { (error) in
                        if error != nil {
                            // show error message
                            self.showError("Error saving user data")
                        }
                    }
                    
                    // Transition to the home screen
                    
                    self.transitionToHome()
                }
            }
            // Transition to the home screen
        }
        
        // Create the user
 */
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
   
    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }




}
