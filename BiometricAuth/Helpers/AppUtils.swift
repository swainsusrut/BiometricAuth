//
//  AppUtils.swift
//  BiometricAuth
//
//  Created by Swain, Susrut (Cognizant) on 20/02/25.
//

import UIKit

class AppUtils {
    
    static func addGradient(view: UIView) {
        // In iOS, there is a class CAGradientLayer to apply gradient colors to views.
        // The CAGradientLayer class provides different properties like colors, locations, points, frame, etc.
        // Atlast, we will use the insertSublayer method to add the gradient layer to the super view.
        
        let gradientLayer = CAGradientLayer()
        
        // You can specify more than one color according to your requirements.
        gradientLayer.colors = [UIColor.darkGray.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        // Set the start and end points for the gradient layer
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        // Set the frame to the layer
        gradientLayer.frame = view.frame
        
        // Add the gradient layer as a sublayer to the background view
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    static func showErrorAlert(message: String, controller: UIViewController) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        controller.present(alert, animated: true)
    }
}
