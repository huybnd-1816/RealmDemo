//
//  RealmConfigure.swift
//  RealmDemo
//
//  Created by nguyen.duc.huyb on 6/6/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmConfigure {
    // MARK: - Properties
    static let currentSchemaVersion: UInt64 = 1
    
    static func configureMigration() {
        //Step 1: Create realm configure
        var config = Realm.Configuration(schemaVersion: currentSchemaVersion, migrationBlock: { (migration, oldSchemaVersion) in
            if oldSchemaVersion < 1 {
                migrateFrom0To1(with: migration)
            }
            
//            if oldSchemaVersion < 2 {
//                migrateFrom1To2(with: migration)
//            }
        })
        
        config.encryptionKey = getKey() as Data
        
        //Step 2: Set configuration of realm and create Realm()
        Realm.Configuration.defaultConfiguration = config
        
        do {
            RealmService.shared.realmDB = try Realm(configuration: config)
        } catch let error as NSError {
            print("Error opening realm: \(error)")
        }
    }
    
    // MARK: - Migrations
    static func migrateFrom0To1(with migration: Migration) {
        migration.renameProperty(onType: User.className(), from: "name", to: "fullname")
    }
    
    static func migrateFrom1To2(with migration: Migration) {
        // Add an email property
        migration.enumerateObjects(ofType: User.className()) { (_, newUser) in
            newUser?["email"] = ""
        }
    }
}

extension RealmConfigure {
    //Create encryption key
    static func getKey() -> NSData {
        // Identifier for our keychain entry - should be unique for your application
        let keychainIdentifier = "io.Realm.EncryptionExampleKey"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        // First check in the keychain for an existing key
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]
        
        // To avoid Swift optimization bug, should use withUnsafeMutablePointer() function to retrieve the keychain item
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return dataTypeRef as! NSData
        }
        
        // No pre-existing key from this application, so generate a new one
        let keyData = NSMutableData(length: 64)!
        let result = SecRandomCopyBytes(kSecRandomDefault, 64, keyData.mutableBytes.bindMemory(to: UInt8.self, capacity: 64))
        assert(result == 0, "Failed to get random bytes")
        
        // Store the key in the keychain
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: keyData
        ]
        
        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
        
        return keyData
    }
}
