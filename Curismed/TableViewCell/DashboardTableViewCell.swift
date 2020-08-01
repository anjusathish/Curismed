//
//  DashboardTableViewCell.swift
//  Curismed
//
//  Created by PraveenKumar R on 03/05/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {
  
  @IBOutlet weak var viewSessionStatus: UIView!
  @IBOutlet weak var labelAppType: UILabel!
  @IBOutlet weak var labelActivity: UILabel!
  @IBOutlet weak var labelSessionHours: UILabel!
  @IBOutlet weak var imageViewMotorCycle: UIImageView!
  @IBOutlet weak var imageViewClockGif: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    selectionStyle = .none
  }
  
}
