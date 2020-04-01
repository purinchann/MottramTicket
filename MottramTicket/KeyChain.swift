//
//  KeyChain.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import Foundation
import KeychainAccess

class KeyChain {
    
    static func create(dict:[String:String]){
        let keychain = Keychain()
        dict.forEach{ (key, value) in
            do {
                try keychain.set(value, key: key)
            } catch {
                print("error: \(error)")
            }
        }
    }
    
    static func read(key:String, success:@escaping(String?)->Void, failure:@escaping(Error)->Void){
        let keychain = Keychain()
        do {
            let value = try keychain.getString(key)
            success(value)
        } catch  {
            failure(error)
        }
    }
    
    static func read(keys:[String], success:@escaping([String: String])->Void, failure:@escaping(Error)->Void){
        let keychain = Keychain()
        var dict:[String: String] = [:]
        keys.forEach { k in
            do {
                let value = try keychain.getString(k)
                dict[k] = value
            } catch  {
                failure(error)
            }
        }
        success(dict)
    }
    
    static func update(){
        
    }
    
    static func delete(keys:[String]){
        let keychain = Keychain()
        keys.forEach { key in
            do {
                try keychain.remove(key)
            } catch {
                print("error: \(error)")
            }
        }
    }
    
}
