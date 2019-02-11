//
//  Consts.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/4/7.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

var navigationBarHeight: CGFloat {
  return UIScreen.main.bounds.height >= 812 ? 88 : 64
}

var mainWindow: UIWindow? {
  if let window = UIApplication.shared.delegate?.window {
    return window
  }
  return nil
}

var mainNavigationController = mainWindow?.rootViewController as! NavigationController
