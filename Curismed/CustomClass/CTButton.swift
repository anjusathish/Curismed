//
//  CTButton.swift
//  Clear Thinking
//
//  Created by Athiban Ragunathan on 02/07/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CTButton: UIButton {
    
    @IBInspectable var style: Int = 0 {
        didSet {
            updateView()
        }
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func awakeFromNib() {
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch style {
        case 0:
            if shadowLayer == nil {
                
                shadowLayer = CAShapeLayer()
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height/2).cgPath
                shadowLayer.fillColor = UIColor.curismedBlue.cgColor
                
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
                shadowLayer.shadowOpacity = 0.5
                shadowLayer.shadowRadius = 2
                
                layer.insertSublayer(shadowLayer, at: 0)
                self.setTitleColor(UIColor.white, for: .normal)
            }
        case 1:
            layer.cornerRadius = frame.height/2
            layer.borderWidth = 1
            layer.borderColor = UIColor.ctGrgeen.cgColor
        case 2:
            
            if shadowLayer != nil {
                shadowLayer.removeFromSuperlayer()
                shadowLayer = nil
            }
            layer.cornerRadius = frame.height/2
            backgroundColor = UIColor.curismedBlue
            setTitleColor(UIColor.white, for: .normal)
            
        default: break
        }
    }
    
    func updateView() {
        
        switch style {
        case 0:
            if shadowLayer != nil {
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height/2).cgPath
                shadowLayer.fillColor = UIColor.curismedBlue.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
                shadowLayer.shadowOpacity = 0.5
                shadowLayer.shadowRadius = 2
                self.setTitleColor(UIColor.white, for: .normal)
            }
        case 1:
            layer.cornerRadius = frame.height/2
            layer.borderWidth = 1
            layer.borderColor = UIColor.ctGrgeen.cgColor
        case 2:
            layer.cornerRadius = frame.height/2
            backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            setTitleColor(UIColor.white, for: .normal)
            
        default: break
        }
    }
}
