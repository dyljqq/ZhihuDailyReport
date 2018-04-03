//
//  UIColor+Ext.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/4/2.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

extension UIColor {
  
  convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1.0) {
    self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
  }
  
  convenience init(hex: Int, alpha: CGFloat = 1.0) {
    let r = (hex & 0xff0000) >> 16
    let g = (hex & 0x00ff00) >> 8
    let b = (hex & 0x0000ff)
    self.init(r: r, g: g, b: b, a: alpha)
  }
  
}
