//
//  Color.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/4/2.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

func UIColorFromRGB(_ rgbValue: UInt, alpha: CGFloat = 1.0) -> UIColor {
  return UIColor(
    red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
    green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
    blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
    alpha: alpha
  )
}

struct Color {
  static let main = UIColor(hex: 0xf0473d)
  static let text = UIColor(hex: 0x222222)
  static let background = UIColor(hex: 0xf5f5f5)
  static let navigation = UIColor(r: 1, g: 131, b: 209)
  static let lightColor = UIColor.lightGray
}
