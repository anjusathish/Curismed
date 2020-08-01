//
//  ColorExtension.swift
//  Customer
//
//  Created by Athiban Ragunathan on 24/11/17.
//  Copyright © 2017 Athiban Ragunathan. All rights reserved.
//

import UIKit

extension UIColor {
  
  static var curismedBlue = UIColor(hex: 0x377EB1, alpha: 1.0)
  static var curismedLightBlue = UIColor(hex: 0xD4E9F0, alpha: 1.0)
  static var curismedLightBlue1 = UIColor(hex: 0xA1BDCC, alpha: 1.0)
  static var curismedConfirmed = UIColor(hex: 0x65A2DE, alpha: 1.0)
  static var curismedRendered = UIColor(hex: 0x55B861, alpha: 1.0)
  static var curismedCancelled = UIColor(hex: 0xB03323, alpha: 1.0)
  static var curismedOthers = UIColor(hex: 0xDAC642, alpha: 1.0)
  
  static var ctGray = UIColor(hex: 0xF6F6F6, alpha: 1.0)
  static var ctGrgeen = UIColor(hex: 0x20B8AB, alpha: 1.0)
  static var ctBorderGray = UIColor(hex: 0xF4F4F4, alpha: 1.0)
  static var ctMenuGray = UIColor(hex: 0x7E98A4, alpha: 1.0)
  static var ctBorderLightGray = UIColor(hex: 0xC4C4C4, alpha: 1.0)
  static var ctMenuGraySelected = UIColor(hex: 0x3E4A57, alpha: 1.0)
  static var ctBlack = UIColor(hex: 0x363636, alpha: 1.0)
  static var ctLightGray = UIColor(hex: 0x8A8A8A, alpha: 1.0)
  
  
  convenience init(hex: UInt32, alpha: CGFloat) {
    let red = CGFloat((hex & 0xFF0000) >> 16)/256.0
    let green = CGFloat((hex & 0xFF00) >> 8)/256.0
    let blue = CGFloat(hex & 0xFF)/256.0
    
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
