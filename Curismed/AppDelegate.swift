//
//  AppDelegate.swift
//  Curismed
//
//  Created by PraveenKumar R on 02/05/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import UIKit
import SideMenuSwift
import IQKeyboardManagerSwift
import DropDown
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    IQKeyboardManager.shared.enable = true
    SideMenuController.preferences.basic.position = .sideBySide
    
    GMSPlacesClient.provideAPIKey("AIzaSyDd19c1-w0ypHJTVqdYjmoT4DMe3tuA-Yo")
    
    SideMenuController.preferences.basic.menuWidth = 300
    SideMenuController.preferences.basic.statusBarBehavior = .hideOnMenu
    SideMenuController.preferences.basic.position = .under
    SideMenuController.preferences.basic.direction = .left
    SideMenuController.preferences.basic.enablePanGesture = true
    SideMenuController.preferences.basic.supportedOrientations = .portrait
    SideMenuController.preferences.basic.shouldRespectLanguageDirection = true
    if #available(iOS 13.0, *) {
      window?.overrideUserInterfaceStyle = .light
    }

    return true
  }
    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.set(ConstantObj.Data.names, forKey: "ConstantObj")
        UserDefaults.standard.set(ConstantObj.Data.clock, forKey: "ConstantObjClock")
    }
  // MARK: UISceneSession Lifecycle
  
  @available(iOS 13.0, *)
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  @available(iOS 13.0, *)
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
  
  // MARK: - DEV METHODS
  class func getAppdelegateInstance() -> AppDelegate?{
    let appDelegateRef = UIApplication.shared.delegate as! AppDelegate
    return appDelegateRef
  }
  
  
}

