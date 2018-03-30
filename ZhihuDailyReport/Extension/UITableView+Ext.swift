//
//  UITableView+Ext.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/3/30.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

extension UITableView {
  
  func dequeue<T>() -> T {
    return dequeueReusableCell(withIdentifier: String(describing: T.self)) as! T
  }
  
}
