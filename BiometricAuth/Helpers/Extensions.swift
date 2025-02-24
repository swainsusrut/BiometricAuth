//
//  Extensions.swift
//  BiometricAuth
//
//  Created by Swain, Susrut (Cognizant) on 20/02/25.
//

import UIKit
import LocalAuthentication

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        // Whether touches are delivered to a view when a gesture is recognised
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// Extension to check supported Biometric type in the device even if its not enrolled
extension LAContext {
    enum BiometricType: String {
        case none
        case touchID
        case faceID
        case opticID
        case unknown
    }

    var currentPolicy: LAPolicy {
        .deviceOwnerAuthentication
    }
    
    // Check policy availability to make sure that you actually have the ability to use device authentication.
    var canEvaluatePolicy: Bool {
        var error: NSError?
        let canEvaluate = self.canEvaluatePolicy(currentPolicy, error: &error)
        
        // Capture these recoverable error through Crashlytics
        print(error?.localizedDescription ?? "")
        
        return canEvaluate
    }
    
    var biometricType: BiometricType {
        guard canEvaluatePolicy else {
            return .none
        }

        if #available(iOS 11.0, *) {
            switch self.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            case .opticID:
                return .opticID
            @unknown default:
                #warning("Handle new Biometric type")
                return .unknown
            }
        } else {
            return .touchID
        }
    }
}
