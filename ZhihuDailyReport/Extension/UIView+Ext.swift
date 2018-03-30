//
//  UIView+Ext.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/3/30.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

extension UIView {
  
  static var className: String {
    return String(describing: self.classForCoder())
  }
  
  static var nib: UINib {
    return UINib(nibName: className, bundle: nil)
  }
  
  class func loadFromNib() -> UIView? {
    return self.nib.instantiate(withOwner: nil, options: nil)[0] as? UIView
  }
  
}
