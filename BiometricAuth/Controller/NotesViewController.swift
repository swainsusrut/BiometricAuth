//
//  NotesViewController.swift
//  BiometricAuth
//
//  Created by Swain, Susrut (Cognizant) on 20/02/25.
//

import Foundation
import UIKit

class NotesViewController: UIViewController {
    
    @IBOutlet weak var txtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtView.delegate = self
        txtView.clipsToBounds = true
        txtView.layer.cornerRadius = 20
        self.hideKeyboardWhenTappedAround()

        AppUtils.addGradient(view: self.view)
        loadNotes()
    }
    
    private func loadNotes() {
        txtView.text = UserDefaults.standard.string(forKey: "savedNote") ?? "My secure note..."
    }
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        UserDefaults.standard.set(txtView.text, forKey: "savedNote")
    }
}

extension NotesViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "My secure note..." {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty  {
            textView.text = "My secure note..."
        }
    }
}
