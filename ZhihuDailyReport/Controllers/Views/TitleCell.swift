//
//  TitleCell.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/4/3.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func render(text: String) {
    titleLabel.text = text
  }
    
}
