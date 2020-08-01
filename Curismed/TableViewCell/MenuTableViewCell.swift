//
//  MenuTableViewCell.swift
//  Clear Thinking
//
//  Created by Athiban Ragunathan on 17/07/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
  
  @IBOutlet weak var iconView: UIImageView!
  @IBOutlet weak var menuLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
    // Initialization code
  }
}
