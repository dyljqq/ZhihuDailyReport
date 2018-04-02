//
//  StoryCell.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/4/2.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit
import Kingfisher

class StoryCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var coverImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func render(story: Story) {
    titleLabel.text = story.title
    coverImageView.kf.setImage(with: URL(string: story.image))
  }
    
}
