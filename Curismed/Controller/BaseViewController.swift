//
//  BaseViewController.swift
//  Clear Thinking
//
//  Created by Athiban Ragunathan on 05/07/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import Foundation
import UIKit
import SideMenuSwift
import TTGSnackbar

enum ErrorMessage : String {
  
  case invalidEmail = "Please enter a UserName"
  case invalidPassword = "Please enter a valid Password"
  case invalidClientName = "Please Select Client"
  case invalidAuthorization = "Please Select Authorization"
  case invalidActivity = "Please Select Activity"
  case invalidLocation = "Please Select Location"
  case inVaildDate = "Please Select Date"
  case invaildStartTime = "Please Select StartTime"
  case invaildEndTime = "Please Select End Time"
  
  case invalidOTP = "Please enter a valid OTP"
  case invalidFirstName = "Please enter a valid First Name"
  case invalidLastName = "Please enter a valid Last Name"
  
  case invalidPasswordMismatch = "Password doesn't match"
  case invalidArea = "Please select the area"
  case invalidDOB = "Please select your date of birth"
  case invalidCode = "Please select the country"
  case invalidPromoCode = "Please Enter Promo Code"
  case invalidMobileNumber = "Please enter your mobile number"
  case advSearch = "Please select a search option or use quick search"
  case terms = "Please agree to our terms of use"
  case invalidZipcode = "Please enter a valid Zip code"
  case invalidSuggestion = "Please enter your Suggestion"
  case invalidQuote = "Please enter your Quote"
  case invalidTopic = "Choose from the existing topic list"
  case invalidKeyword = "Please Enter your keyword"
  case invalidAuthor = "Please enter an author"
  case invalidMisconception = "Choose Misconception"
  case topicLimit = "Maximum topics selected, remove one to select new topic"
  case oneTimeSubscription = "Please choose either one subscription"
  case enterPrice = "Please enter an amount"
  case invalidName = "Please Enter Name"
  case invalidAddress = "Please Enter Address"
  case invalidCity = "Please Enter City"
  case invalidstate = "Please Enter State"
  case invalidNotes = "Please Enter Notes"
  case invalidCountry = "Please Enter Country"
  case invalidPaymentUrl = "Invalid Payment Url, Please try again later"
  case invalidAuthorCategory = "Please select author category"
  case selectTopic = "Please select atleast one topic"
  case invalidCardNumber = "Please Enter Valid Card Number"
  case invalidCCV = "Please Enter Valid CCV"
  case invalidMonth = "Please Enter Valid Month"
  case invalidYear = "Please Enter Valid Year"
  case selectCountry = "Please select Country"
  case noTopics = "No Topics Found"
  case favQuotes = "To make a quote as your favorite, click on the bookmark symbol on the quote."
  case noQuotes = "No quotes found.You may want to adjust your search."
  case emptySearch = "To save the quote, click on the save search under advanced search."
  case noSubmit = "No Submitted quotes."
  case invalidSearch = "Select 'Yes' for either Keyword, Topic, Author, or Misconception!"
  case wordsExceed = "Quote Should not allow more than 180 words."
  case invalidAuthors = "Please Choose any Author"
  //  case noSearch = "Search List isEmpty!"
  case noSearch = "Consider refining your search critieria and check wherther the two checkboxes ('Longer Quotes' and 'Advanced Quotes') are checked."
  
}

class BaseViewController: UIViewController {
  
  private let snackbar = TTGSnackbar()
  
  
  var topBarHeight : CGFloat = 60
  var safeAreaHeight : CGFloat {
    get {
      if let window = UIApplication.shared.windows.first {
        if #available(iOS 11.0, *) {
          return window.safeAreaInsets.top
        } else {
          // Fallback on earlier versions
        }
      }
      return 0.0
    }
  }
  
  var userButton : UIButton?
  
  var titleString : String = "" {
    didSet {
      let titleView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: topBarHeight + safeAreaHeight))
      titleView.backgroundColor = UIColor.curismedBlue
      let rectShape = CAShapeLayer()
      rectShape.bounds = titleView.frame
      rectShape.position = titleView.center
      rectShape.path = UIBezierPath(roundedRect: titleView.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
      titleView.layer.mask = rectShape
      self.view.addSubview(titleView)
      
      let menuButton = UIButton(frame: CGRect(x: 16, y: 16 + safeAreaHeight, width: 30, height: 17))
      
      if let controller = self.navigationController?.viewControllers.first {
        
        if controller != self {
          showBackIcon = true
          menuButton.setImage(UIImage(named: "BackIcon"), for: .normal)
          menuButton.tintColor = UIColor.white
        }
        else {
          menuButton.setImage(UIImage(named: "MenuIcon"), for: .normal)
        }
      }
      else {
        menuButton.setImage(UIImage(named: "MenuIcon"), for: .normal)
      }
      
      menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
      titleView.addSubview(menuButton)
      
      
      let titleLabel = UILabel(frame: CGRect(x: 76, y: 10 + safeAreaHeight, width: self.view.frame.width - (76 + 76), height: 30))
      titleLabel.text = titleString
      titleLabel.font = UIFont.systemFont(ofSize: 20)
      titleLabel.textColor = UIColor.white
      titleView.addSubview(titleLabel)
      
      adjustConstraint()
      
    }
  }
  
  var showBackIcon : Bool = false
  
  override func viewDidLoad() {
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    if !titleString.isEmpty {
      adjustConstraint()
    }
    
    
  }
  
  @objc func keyboardWillShow(_ notification: Notification) {
    if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardRectangle = keyboardFrame.cgRectValue
      if notification.name == UIResponder.keyboardWillHideNotification {
        snackbar.bottomMargin = 4
      }
      else {
        snackbar.bottomMargin = keyboardRectangle.height + 4
      }
    }
  }
  
  @objc func menuButtonAction(sender : UIButton) {
    
    if showBackIcon {
      self.navigationController?.popViewController(animated: true)
    }
    else {
      sideMenuController?.revealMenu()
    }
  }
  
  @objc func profileAction(sender : UIButton) {
    
    let profileVC = UIStoryboard.dashboardStoryboard().instantiateViewController(withIdentifier: "ProfileViewController")
    self.navigationController?.pushViewController(profileVC, animated: true)
  }
  
  func adjustConstraint() {
    
    for contstraint in self.view.constraints {
      if isTopConstraint(constraint: contstraint) {
        
        contstraint.constant += (topBarHeight + safeAreaHeight)
        
        break
      }
    }
  }
  
  func isTopConstraint(constraint : NSLayoutConstraint) -> Bool {
    
    return firstTopConstraint(constraint: constraint) || secondTopConstraint(constraint: constraint)
  }
  
  func firstTopConstraint(constraint : NSLayoutConstraint) -> Bool {
    
    if let firstItem = constraint.firstItem as? UIView {
      return firstItem == self.view && constraint.firstAttribute == NSLayoutConstraint.Attribute.top
    }
    return false
  }
  
  func secondTopConstraint(constraint : NSLayoutConstraint) -> Bool {
    
    if let secondItem = constraint.secondItem as? UIView {
      return secondItem == self.view && constraint.secondAttribute == NSLayoutConstraint.Attribute.top
    }
    return false
  }
  
}

extension UITapGestureRecognizer {
  
  func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
    
    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer(size: CGSize.zero)
    let textStorage = NSTextStorage(attributedString: label.attributedText!)
    
    layoutManager.addTextContainer(textContainer)
    textStorage.addLayoutManager(layoutManager)
    
    textContainer.lineFragmentPadding = 0.0
    textContainer.lineBreakMode = label.lineBreakMode
    textContainer.maximumNumberOfLines = label.numberOfLines
    let labelSize = label.bounds.size
    textContainer.size = labelSize
    
    let locationOfTouchInLabel = self.location(in: label)
    let textBoundingBox = layoutManager.usedRect(for: textContainer)
    
    let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
    
    let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
    let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
    return NSLocationInRange(indexOfCharacter, targetRange)
  }
}

extension BaseViewController {
  
  func displayServerSuccess(withMessage message : String){
    snackbar.duration = .long
    snackbar.message = message.replacingOccurrences(of: "message", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "\"", with: "")
    snackbar.show()
  }
  
  func displayServerError(withMessage message : String) {
    snackbar.duration = .long
    snackbar.message = message.replacingOccurrences(of: "message(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "\"", with: "")
    snackbar.show()
  }
  
  func displayError(withMessage message : ErrorMessage) {
    snackbar.duration = .long
    snackbar.message = message.rawValue
    snackbar.show()
  }
  
  func presentLoginVC(){
    
    let viewController = UIStoryboard.onBoardingStoryboard().instantiateViewController(withIdentifier: "login")
    let navController = UINavigationController(rootViewController: viewController)
    navController.isNavigationBarHidden = true
    UIApplication.shared.windows.first?.rootViewController = navController
  }
}

