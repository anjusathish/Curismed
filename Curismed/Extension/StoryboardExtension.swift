//
//  StoryboardExtension.swift
//  Curismed
//
//  Created by PraveenKumar R on 03/05/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import UIKit

extension UIStoryboard{
    
    /**
     Convenience Initializers to initialize storyboard.
     
     - parameter storyboard: String of storyboard name
     - parameter bundle:     NSBundle object
     
     - returns: A Storyboard object
     */
    convenience init(storyboard: String, bundle: Bundle? = nil) {
        self.init(name: storyboard, bundle: bundle)
    }
    
    /**
     Initiate view controller with view controller name.
     
     - returns: A UIView controller object
     */
    func instantiateViewController<T: UIViewController>() -> T {
        var fullName: String = NSStringFromClass(T.self)
        if let range = fullName.range(of: ".", options: .backwards) {
            fullName = String(fullName[range.upperBound...])
        }
        
        guard let viewController = self.instantiateViewController(withIdentifier: fullName) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(fullName) ")
        }
        
        return viewController
    }
    
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    class func dashboardStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "DashBoard", bundle: nil)
    }
    
    class func onBoardingStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Onboarding", bundle: nil)
    }
  
  class func helpStoryboard() -> UIStoryboard {
      return UIStoryboard(name: "Help", bundle: nil)
  }
  
  class func aboutUsStoryboard() -> UIStoryboard {
      return UIStoryboard(name: "AboutUs", bundle: nil)
  }
  
  class func appointmentStoryboard() -> UIStoryboard {
       return UIStoryboard(name: "Appointment", bundle: nil)
   }

}
