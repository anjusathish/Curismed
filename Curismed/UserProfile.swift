//
//  UserProfile.swift
//  Kinder Care
//
//  Created by PraveenKumar R on 29/04/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import UIKit

class UserProfile: NSObject {
  
  private var _saveCurrentUser: User?
  
  var currentUser : User? {
    get {
      return _saveCurrentUser
    }
    set {
      _saveCurrentUser = newValue
      
      if let _ = _saveCurrentUser {
        saveUser()
      }
    }
  }
  
  class var shared: UserProfile {
    struct Singleton {
      static let instance = UserProfile()
    }
    return Singleton.instance
  }
  
  private struct SerializationKeys {
    static let activeUser = "currentUser"
  }
  
  private override init () {
    super.init()
    if isLoggedInUser() {
      getUser()
    }
  }
  
  func isLoggedInUser() -> Bool {
     
     guard let _ = UserDefaults.standard.object(forKey: SerializationKeys.activeUser)
       else {
         return false
     }
     return true
   }
  
  func saveUser() {
    
    if let user = _saveCurrentUser {
      let encoder = JSONEncoder()
      if let encoded = try? encoder.encode(user) {
        let defaults = UserDefaults.standard
        defaults.set(encoded, forKey: SerializationKeys.activeUser)
      }
    }
  }
  
  func getUser() {
    
    let defaults = UserDefaults.standard
    if let savedPerson = defaults.object(forKey: SerializationKeys.activeUser) as? Data {
      
      let decoder = JSONDecoder()
      if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
        currentUser = loadedPerson
      }
    }
  }
}

