//
//  Date+Ext.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/3/30.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import Foundation

fileprivate let oneDaySeconds = 24 * 60 * 60

extension Date {
  
  static func diff(day: TimeInterval) -> String {
    let timeInterval: TimeInterval = day * 24 * 60 * 60
    let date = Date(timeIntervalSinceNow: timeInterval)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    return formatter.string(from: date)
  }
  
}
