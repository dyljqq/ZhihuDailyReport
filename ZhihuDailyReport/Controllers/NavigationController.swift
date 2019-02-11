//
//  NavigationController.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/4/7.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    hideShadowImage()
  }
  
  override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    super.pushViewController(viewController, animated: animated)
  }
  
  override func popViewController(animated: Bool) -> UIViewController? {
    let vc = super.popViewController(animated: true)
    return vc
  }
  
  func hideShadowImage() {
    self.navigationBar.shadowImage = UIImage()
  }
  
}
