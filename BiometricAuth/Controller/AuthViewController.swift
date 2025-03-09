//
//  AuthViewController.swift
//  BiometricAuth
//
//  Created by Swain, Susrut (Cognizant) on 20/02/25.
//

import UIKit

class AuthViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lblUsePassword: UILabel!
    @IBOutlet weak var unlockBtn: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self

        userNameTextField.isHidden = true
        passwordTextField.isHidden = true
        AppUtils.addGradient(view: self.view)
        
        // create the gesture recognizer
        let labelTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.useCredentials))
        lblUsePassword.isUserInteractionEnabled = true
        lblUsePassword.addGestureRecognizer(labelTapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == userNameTextField {
            retrivePassword()
        }
    }
    
    func retrivePassword() {
        guard let userName = userNameTextField.text, !userName.isEmpty else {
            print("Enter Username to retrive password")
            return
        }
        
        if let savedPassword = KeychainManager.getPassword(for: userName) {
            passwordTextField.text = savedPassword
        } else {
            print("No password found for this username")
        }
    }
        
    @IBAction func btnUnlockTapped(_ sender: UIButton) {
        if unlockBtn.currentTitle == "Sign In" {
            guard let userName = userNameTextField.text, !userName.isEmpty,
                let password = passwordTextField.text, !password.isEmpty else {
                print("Invalid Username or Password")
                return
            }
            
            let credential = Credential(username: userName, password: password)
            let success = KeychainManager.savePassword(for: credential)
            print(success ? "Password saved sucessfully" : "Failed to save password")
            
            navigateToNotesController()
            updateView()
        } else {
            //Use Biometric
            if (BiometricAuthManager.shared.currentAuthenticationState == .authenticated) {
                navigateToNotesController()
                return
            }
            
            BiometricAuthManager.shared.authenticateUser { [self] authState, errorMessage in
                if authState == .authenticated {
                    navigateToNotesController()
                    updateView()
                } else {
                    AppUtils.showErrorAlert(message: errorMessage ?? "Something went wrong", controller: self)
                }
            }
        }
    }
    
    @objc func useCredentials() {
        lblUsePassword.isHidden = true
        userNameTextField.isHidden = false
        passwordTextField.isHidden = false
        
        unlockBtn.setTitle("Sign In", for: .normal)
    }
        
    private func navigateToNotesController() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destinationController = storyboard.instantiateViewController(withIdentifier: "NotesViewControllerId") as! NotesViewController
        
        destinationController.modalPresentationStyle = .formSheet
        destinationController.modalTransitionStyle = .crossDissolve
        
        self.present(destinationController, animated: true, completion: nil)
    }
        
    func updateView() {
        unlockBtn.setTitle("View Note", for: .normal)
        userNameTextField.isHidden = true
        passwordTextField.isHidden = true
    }
}

