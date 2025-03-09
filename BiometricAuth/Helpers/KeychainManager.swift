//
//  KeychainManager.swift
//  BiometricAuth
//
//  Created by Swain, Susrut (Cognizant) on 07/03/25.
//

/*
 The keychain services API helps you solve this problem by giving your app a mechanism to store small bits of user data in an encrypted database called a keychain (mostly passwords). You can store other secrets that the user explicitly cares about, such as credit card information or even short notes.
 
 Keychain is an encrypted database stored on disk.
 When you want to store a secret such as a password or cryptographic key, you package it as a keychain item.
 Keychain services handles data encryption and storage. Later, authorized processes use keychain services to find the item and decrypt its data.
 
 secItemAdd - Adds a new item to the Keychain
 secItemCopyMatching - Retrives an item from the Keychain
 secItemUpdate - Updates an existing keychain item.
 secItemDelete - Deletes an item from the keychain.
 */

import Security
import Foundation

class KeychainManager {
    static func savePassword(for account: Credential) -> Bool {
        let passwordData = account.password.data(using: .utf8)
        
        var query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: Bundle.main.bundleIdentifier as AnyObject,
                                    kSecAttrAccount as String: account.username,
                                    kSecValueData as String: passwordData as AnyObject]
        
        SecItemDelete(query as CFDictionary)
        let response = SecItemAdd(query as CFDictionary, nil)
        return response == errSecSuccess
    }
    
    static func getPassword(for username: String) -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: Bundle.main.bundleIdentifier as AnyObject,
                                    kSecAttrAccount as String: username,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnData as String: true]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }
    
    static func deletePassword(for account: Credential) -> Bool {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: Bundle.main.bundleIdentifier as AnyObject,
                                    kSecAttrAccount as String: account.username]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
