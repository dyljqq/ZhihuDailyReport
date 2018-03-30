//
//  UITableViewCell+Ext.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/3/30.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

extension UITableViewCell {
  
  class func registerClass(_ tableView: UITableView) {
    tableView.register(classForCoder(), forCellReuseIdentifier: className)
  }
  
  class func registerNib(_ tableView: UITableView) {
    tableView.register(nib, forCellReuseIdentifier: className)
  }
  
}
