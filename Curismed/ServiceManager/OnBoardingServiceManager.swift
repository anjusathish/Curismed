//
//  OnBoardingManager.swift
//  Bungkus
//
//  Created by Athiban Ragunathan on 12/07/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import Foundation
enum ContentType : String {
  case x_www_form_urlEncoded = "application/x-www-form-urlencoded"
  case json = "application/json"
}

enum OnBoardingServiceManager {
  
  case login(_ info: LoginRequest)
  case forgotpassword(_ info : ForgotPasswordRequest)
  
  
  var scheme: String {
    switch self {
    case .login,.forgotpassword: return API.scheme
    }
  }
  
  var host: String {
    switch self {
    case .login,.forgotpassword : return API.baseURL
    }
  }
  
  var path: String {
    switch self {
    case .login: return "/login"
    case .forgotpassword: return "/user/forgotpassword"
    }
  }
  
  var method: String {
    switch self {
    case .login,.forgotpassword: return "POST"
    }
  }
  
  var parameters: [URLQueryItem]? {
    switch self {
    case .login,.forgotpassword:
      return nil
      
    }
  }
  
  var body: Data? {
    
    switch self {
    case .login(let request):
      print(request)
      let encoder = JSONEncoder()
      return try? encoder.encode(request)
      
    case .forgotpassword(let request):
      print(request)
      let encoder = JSONEncoder()
      return try? encoder.encode(request)
    }
  }
  
  var headerFields: [String : String] {
    switch self {
    case .login,.forgotpassword:
      return [:]
    }
  }
  
}
