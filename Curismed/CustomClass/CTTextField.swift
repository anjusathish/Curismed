//
//  CTTextField.swift
//  Clear Thinking
//
//  Created by Athiban Ragunathan on 02/07/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import Foundation
import UIKit

enum ValidationRule : String {
    
    case email = "email"
    case phoneNumber = "phoneNumber"
    case pincode = "pincode"
    
    var validationMessage : String {
        get {
            switch self {
            case .email:
                return "Invalid email"
            case .phoneNumber:
                return "Invalid phone number"
            case .pincode:
                return "Invalid postal code"
            }
        }
    }
}

@IBDesignable
class CTTextField: UITextField, UITextFieldDelegate {
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 20
    
    @IBInspectable var style: Int = 0 {
        didSet {
            design()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 20
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var bgcolor: UIColor = UIColor.ctGray {
        didSet {
            design()
        }
    }
    
    @IBInspectable var rightViewRect: CGSize = CGSize(width: 20, height: 20) {
        didSet {
            updateView()
        }
    }
    
    var rule : ValidationRule? {
        didSet {
            delegate = self
        }
    }
    
    private var shadowLayer: CAShapeLayer!
    private var leftImageView : UIImageView?
    private var rightImageView : UIImageView?
    private var isSecureField : Bool = false
    
    override func awakeFromNib() {
        
        if isSecureTextEntry {
            isSecureField = true
            rightViewMode = UITextField.ViewMode.always
            rightImageView = UIImageView(frame: CGRect(origin: .zero, size: rightViewRect))
            rightImageView?.contentMode = .scaleAspectFit
            rightImageView?.image = UIImage(named: "showPasswordIcon")
            rightView = rightImageView
            rightView?.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showPasswordAction))
            rightView?.addGestureRecognizer(tapGesture)
        }
        
        self.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil { 
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.shadowPath = shadowLayer.path
            layer.cornerRadius = 20
            design()
            leftImageView?.tintColor = UIColor.gray
            rightImageView?.tintColor = UIColor.gray
          tintColor = UIColor.curismedBlue
        }
    }
    
    @objc func showPasswordAction() {
        isSecureTextEntry = !isSecureTextEntry
        rightView?.tintColor = isSecureTextEntry ? UIColor.darkGray : UIColor.curismedBlue
    }
    
    func design() {
        
        switch style {
        case 0:
          layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            layer.borderWidth = 1
            layer.cornerRadius = 5
            textColor = UIColor.curismedBlue
          
        case 1:
            
            if shadowLayer != nil {
                shadowLayer.fillColor = bgcolor.cgColor
                shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
                shadowLayer.shadowOpacity = 0.0
                shadowLayer.shadowRadius = 5
                shadowLayer.borderWidth = 1
                shadowLayer.borderColor = UIColor.ctBorderGray.cgColor
                layer.insertSublayer(shadowLayer, at: 0)
            }
        default: break
        }
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//        if let text = textField.text {
//
//            if let _rule = rule {
//
//                switch _rule {
//
//                case .email: text.isValidEmail() ? setError() : setError(_rule.validationMessage,show: false)
//                case .phoneNumber: text.isValidPhone() ? setError() : setError(_rule.validationMessage,show: false)
//                case .pincode: text.count == 4 ? setError() : setError(_rule.validationMessage,show: false)
//                }
//            }
//        }
//    }
    
    @objc func textFieldDidChange(textField : UITextField) {
        
        if let text = textField.text {
                      
            if text.isEmpty {
                
                switch style {
                case 0 :
                    layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
                case 1 :
                    shadowLayer.fillColor = UIColor.ctGray.cgColor
                    shadowLayer.shadowOpacity = 0.0
                  layer.borderColor = UIColor.clear.cgColor
                    layer.borderWidth = 0
                  layer.cornerRadius = 5
                default : break
                }
                
                leftImageView?.tintColor = UIColor.darkGray
                
                if !isSecureField {
                    rightImageView?.tintColor = UIColor.darkGray
                }
            }
            else {
                
                switch style {
                case 0 :
                    layer.borderColor = UIColor.curismedBlue.cgColor
                case 1 :
                    shadowLayer.fillColor = UIColor.white.cgColor
                    layer.borderColor = UIColor.curismedBlue.cgColor
                    layer.borderWidth = 1
                    layer.cornerRadius = 5
                default : break
                }
                
                leftImageView?.tintColor = UIColor.curismedBlue
                
                if !isSecureField {
                    rightImageView?.tintColor = UIColor.curismedBlue
                }
            }
        }
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= leftPadding
        return textRect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.textRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        textRect.size.width -= leftPadding
        return textRect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.editingRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        textRect.size.width -= leftPadding
        return textRect
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            leftImageView?.contentMode = .scaleAspectFit
            leftImageView?.image = image
            leftView = leftImageView
        }
        
        if let image = rightImage {
            
            if !isSecureField {
                rightViewMode = UITextField.ViewMode.always
                rightImageView = UIImageView(frame: CGRect(origin: .zero, size: rightViewRect))
                rightImageView?.contentMode = .scaleAspectFit
                rightImageView?.image = image
                rightView = rightImageView
            }
        }
        else {
            rightImageView = nil
            rightView = nil
        }
    }
}
