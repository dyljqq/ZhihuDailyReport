//
//  ImageName.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/7/31.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

enum ImageName: String {
  case pullArrow = "pull_arrow"
  case iconMenuBlack = "ic_menu_black"
}

extension UIImage {
  convenience init?(imageName: ImageName) {
    self.init(named: imageName.rawValue)
  }
}
