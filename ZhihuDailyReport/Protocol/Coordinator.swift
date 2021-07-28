//
//  Coordinator.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2019/2/11.
//  Copyright © 2019 dyljqq. All rights reserved.
//

import UIKit

protocol Coordinator {
  
  var navigationViewController: UINavigationController { get set}
  
  func start()
  
}
