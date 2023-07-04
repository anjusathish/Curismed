//
//  LoginViewController.swift
//  Curismed
//
//  Created by PraveenKumar R on 03/05/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import UIKit
import ContactsUI

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var viewBackGroundImage: UIView!
    @IBOutlet weak var textName: CTTextField!
    @IBOutlet weak var textPassword: CTTextField!
    
    lazy var viewModel : LoginViewModel = {
        return LoginViewModel()
    }()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        viewBackGroundImage.roundCorners([.bottomLeft,.bottomRight], cornerRadius: 75)
        viewBackGroundImage.clipsToBounds = true
    }
    
    //MARK:- UIButton Action
    @IBAction func loginAction(_ sender: Any) {
        guard let userName = textName.text, !userName.removeWhiteSpace().isEmpty else {
            displayError(withMessage: .invalidEmail)
            return
        }
        guard let password = textPassword.text, !password.removeWhiteSpace().isEmpty else {
            displayError(withMessage: .invalidPassword)
            return
        }
        
        let request = LoginRequest(email: userName, password: password)
        viewModel.loginUser(info: request)
        
    }
}

extension UIView {
    
    func roundCorners(_ corners:UIRectCorner, cornerRadius: Double) {
        
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
    }
}

extension LoginViewController: LoginDelegate{
    func loginSuccessfull() {
        let submittedquotevc = UIStoryboard.dashboardStoryboard().instantiateViewController(withIdentifier: "SideMenuController")
        self.navigationController?.pushViewController(submittedquotevc, animated: true)
    }
    
    func failure(message: String) {
        print(message)
        displayServerError(withMessage: message)
    }
    
    
}

//MARK:- TextField Delegate methods
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        return true
    }
}


