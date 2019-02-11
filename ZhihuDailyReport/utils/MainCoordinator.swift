//
//  MainCoordinator.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2019/2/11.
//  Copyright © 2019 dyljqq. All rights reserved.
//

import UIKit


class MainCoordinator: Coordinator {
  
  var navigationViewController: UINavigationController
  
  init(_ navigationViewController: UINavigationController) {
    self.navigationViewController = navigationViewController
  }
  
  func start() {
    guard let vc = self.navigationViewController.topViewController as? MainViewController else { return }
    vc.coordinator = self
  }
  
}

extension MainCoordinator {
  
  func pushDetailStoryViewController(storyId: Int) {
    print("push detail story...")
  }
  
}
