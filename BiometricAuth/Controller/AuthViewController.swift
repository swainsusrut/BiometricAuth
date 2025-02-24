//
//  AuthViewController.swift
//  BiometricAuth
//
//  Created by Swain, Susrut (Cognizant) on 20/02/25.
//

import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var unlockBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        AppUtils.addGradient(view: self.view)
    }
        
    @IBAction func btnUnlockTapped(_ sender: UIButton) {
        if (BiometricAuthManager.shared.currentAuthenticationState == .authenticated) {
            navigateToNotesController()
            return
        }
        
        BiometricAuthManager.shared.authenticateUser { [self] authState, errorMessage in
            if authState == .authenticated {
                navigateToNotesController()
                unlockBtn.setTitle("View Note", for: .normal)
            } else {
                AppUtils.showErrorAlert(message: errorMessage ?? "Something went wrong", controller: self)
            }
        }
    }
        
    private func navigateToNotesController() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destinationController = storyboard.instantiateViewController(withIdentifier: "NotesViewControllerId") as! NotesViewController
        
        destinationController.modalPresentationStyle = .formSheet
        destinationController.modalTransitionStyle = .crossDissolve
        
        self.present(destinationController, animated: true, completion: nil)
    }
}

