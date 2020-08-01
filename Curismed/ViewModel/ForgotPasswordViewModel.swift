//
//  ForgotPasswordViewModel.swift
//  Clear Thinking
//
//  Created by CIPL0651 on 23/07/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import Foundation

protocol ForgotPasswordDelegate{
  func forgotpasswordSuccess(message : String)
  func forgotpasswordFailure(message : String)
}

struct ForgotPasswordRequest : Codable {
  let username : String
  let _token :String
}

class ForgotPasswordViewModel{
  
  var delegate : ForgotPasswordDelegate?
  
  func forgotPassword(info: ForgotPasswordRequest){
    
    OnBoardingServiceHelper.request(router: OnBoardingServiceManager.forgotpassword(info), completion: { (result : Result<ForgotpasswordResponse, CustomError>) in
      
      DispatchQueue.main.async {
        switch result{
        case .success(let _):
          self.delegate?.forgotpasswordSuccess(message: "success")
        case .failure(let message):
          self.delegate?.forgotpasswordFailure(message: "\(message)")
        }
      }
    })
  }
}

