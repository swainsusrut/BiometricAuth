//
//  BiometricAuthManager.swift
//  BiometricAuth
//
//  Created by Swain, Susrut (Cognizant) on 20/02/25.
//

import Foundation
import LocalAuthentication

/*
 NOTES:-
 // Users love Touch ID and Face ID because these authentication mechanisms let them access their devices securely, with minimal effort.
 // Always provide a fallback option for when biometrics aren’t available.

 // Include the NSFaceIDUsageDescription key in your app’s Info.plist file. Without this key, the system won’t allow your app to use Face ID. The system doesn’t require a comparable usage description for Touch ID.
 // You perform biometric authentication in your app using an LAContext instance
 // Before attempting to authenticate, test policy availability to make sure that you actually have the ability to do so.
 // If you ask for the deviceOwnerAuthenticationWithBiometrics policy then you will have to handle the fallback yourself else it fails with a LAError.Code.userFallback error
 // If you ask for deviceOwnerAuthentication only, then biometrics will be used if available and authorized, otherwise it will automatically fall back to passcode if biometrics is unavailable, or give you the fallback option to enter passcode automatically if biometrics attemps fail.
 // In a real app, if you encounter a local authentication error, fall back to your own authentication scheme, like asking for a username and password.
 // Use biometrics as a supplement to something you’re already doing. Don’t depend on biometrics as your only authentication option.
 */


public enum AuthenticationState {
    case authenticated
    case unauthenticated

    public func isAuthenticated() -> Bool {
        return self == .authenticated
    }
}

class BiometricAuthManager {
    static let shared = BiometricAuthManager()
    var currentAuthenticationState: AuthenticationState = .unauthenticated
    
    private init() {}
    
    func authenticateUser(completion: @escaping (AuthenticationState, String?) -> Void) {
        let context = LAContext()
        
        //Not reliable
        print(context.biometricType.rawValue)
        
        // If deviceOwnerAuthenticationWithBiometrics is selected, and Biometry is available and is enrolled
        // If deviceOwnerAuthentication is selected, and Biometry is not available or is not enrolled, it will fallback to passcode, otherwise it will pick up Biometry
        if context.canEvaluatePolicy {
            
            context.evaluatePolicy(context.currentPolicy, localizedReason: "Authenticate to access Secure Notes") { success, authError in
                DispatchQueue.main.async { [self] in
                    if success {
                        currentAuthenticationState = .authenticated
                        completion(currentAuthenticationState, nil)
                    } else {
                        let message = authError?.localizedDescription ?? "Authentication failed"
                        currentAuthenticationState = .unauthenticated
                        completion(currentAuthenticationState, message)
                    }
                }
            }
            
        } else {
            //If selected policy is deviceOwnerAuthenticationWithBiometrics, && Biometry is not enrolled || No Biometry is available
            //Here it won't fall back to passcode, so fall back to your own authentication scheme
            DispatchQueue.main.async { [self] in
                currentAuthenticationState = .unauthenticated
                completion(currentAuthenticationState, "Authentication is not available")
            }
            
        }
    }
}
