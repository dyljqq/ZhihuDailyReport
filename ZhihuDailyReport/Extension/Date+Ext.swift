//
//  Date+Ext.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/3/30.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import Foundation

fileprivate let oneDaySeconds = 24 * 60 * 60
fileprivate let dateFormat = "yyyyMMdd"

extension Date {
  
  static func diff(day: TimeInterval) -> String {
    let timeInterval: TimeInterval = day * 24 * 60 * 60
    let date = Date(timeIntervalSinceNow: timeInterval)
    
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    return formatter.string(from: date)
  }
  
  static func to(dateString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    return formatter.date(from: dateString)
  }
  
}
