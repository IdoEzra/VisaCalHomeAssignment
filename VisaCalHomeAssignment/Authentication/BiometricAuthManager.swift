//
//  BiometricAuth.swift
//  VisaCalHomeAssignment
//
//  Created by Ido Ezra on 27/10/2024.
//

import Foundation
import LocalAuthentication

class BiometricAuthManager {
    
    func encryptAndStore(data: Data, key: String, completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        // Check if biometrics is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let accessControl = SecAccessControlCreateWithFlags(
                kCFAllocatorDefault,
                kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                .userPresence,
                nil
            )!
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data,
                kSecAttrAccessControl as String: accessControl
            ]
            
            // Store data in the keychain
            SecItemDelete(query as CFDictionary) // Ensure old item is removed before adding
            let status = SecItemAdd(query as CFDictionary, nil)
            completion(status == errSecSuccess)
        } else {
            completion(false)
        }
    }
    
    func retrieveAndDecrypt(key: String, completion: @escaping (Data?) -> Void) {
        let context = LAContext()
        context.localizedReason = "Authenticate to access the recipe"
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecUseAuthenticationContext as String: context,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess {
            if let data = item as? Data {
                completion(data)
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }
}
