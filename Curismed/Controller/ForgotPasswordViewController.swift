//
//  ForgotPasswordViewController.swift
//  Curismed
//
//  Created by PraveenKumar R on 03/05/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
  
  @IBOutlet weak var txtUserName: CTTextField!
  
  lazy var viewModel : ForgotPasswordViewModel = {
    return ForgotPasswordViewModel()
  }()
  
  //MARK:- ViewController LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    titleString = "Forgot Password"
    viewModel.delegate = self
    
  }
  
  
  //MARK:- UIButton Action
  @IBAction func buttonSubmit(_ sender: Any) {
    
    guard let userName = txtUserName.text, !userName.removeWhiteSpace().isEmpty else {
      displayError(withMessage: .invalidEmail)
      return
    }
    
    let request = ForgotPasswordRequest(username: userName, _token: "kaYfoHVjbZKkd8uOs0Ddn9dXQv0CkZSO7Z7hWXUK")
    viewModel.forgotPassword(info: request)
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}

extension ForgotPasswordViewController: ForgotPasswordDelegate{
  
  func forgotpasswordSuccess(message: String) {
    
    self.displayServerError(withMessage: "Forgot Password rest successfully")
    self.navigationController?.popViewController(animated: true)
    
  }
  
  func forgotpasswordFailure(message: String) {
    
    self.displayServerError(withMessage: message)
    
  }
  
  
}
