//
//  Constants.swift
//  iJob
//
//  Created by Athiban Ragunathan on 07/01/18.
//  Copyright © 2018 Athiban Ragunathan. All rights reserved.
//

import UIKit

struct REGEX {
  static let phone_indian = "^(?:(?:\\+|0{0,2})91(\\s*[\\-]\\s*)?|[0]?)?[789]\\d{9}$"
  static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
}

struct AppFontName {
  static let regular = "Roboto-Regular"
  static let bold = "Roboto-Bold"
  static let italic = "CourierNewPS-ItalicMT"
}

struct STORYBOARD {
  
  static let OTPViewcontrollerIdentifier = "OTPVerificationViewController"
}

enum GrantType : String {
  case password = "password"
  case refreshToken = "refresh_token"
}

struct API {
  
  static let baseURL = "app.curismed.com"
  static let stateBaseURL = "gosigmaway.com"
  static let scheme = "https"
  static let stateScheme = "http"
}


struct GOOGLE {
  static let placesAPI_KEY = "AIzaSyBqOCrPjA9IXTn8pHiNozi6cWI91oIetG0"
}

struct DEVICE {
  static let deviceType = "2"
  static let deviceModel = UIDevice.current.model
  static let systemVersion = UIDevice.current.systemVersion
  static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
  static let buildNo = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "100"
}

class Constants: NSObject {
  static let shared = Constants()
  static let appDelegateRef : AppDelegate = AppDelegate.getAppdelegateInstance()!
  static var LAST_SELECTED_INDEX_N_PICKER = 0
  
  // Custom Date Picker
  class func viewControllerWithName(identifier: String) ->UIViewController {
    let storyboard = UIStoryboard(name: "Leave", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: identifier)
  }
}
