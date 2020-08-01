//
//  LoginViewModel.swift
//  Bungkus
//
//  Created by Athiban Ragunathan on 12/07/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import Foundation

protocol LoginDelegate {
  func loginSuccessfull()
  func failure(message : String)
}

struct LoginRequest : Codable {
  let username : String
  let password : String
  let _token :String
}

class LoginViewModel {
  
  var delegate : LoginDelegate?
  
  func loginUser(info: LoginRequest) {
    
    OnBoardingServiceHelper.request(router: OnBoardingServiceManager.login(info), completion: { (result : Result<LoginResponse, CustomError>) in
      
      DispatchQueue.main.async {
        switch result {
          
        case .success(let response):
          
          UserProfile.shared.currentUser = response.data
          self.delegate?.loginSuccessfull()
          
        case .failure(let message): self.delegate?.failure(message: "\(message)")
          
        }
      }
    })
  }
}
