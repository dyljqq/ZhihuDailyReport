//
//  File.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/3/30.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import Foundation

struct NextPageState {
  
  private(set) var start: Int
  private(set) var hasNext: Bool
  private(set) var isLoading: Bool
  
  init() {
    start = 0
    hasNext = true
    isLoading = false
  }
  
  mutating func reset() {
    start = 0
    hasNext = true
    isLoading = false
  }
  
  mutating func update(start: Int, hasNext: Bool, isLoading: Bool) {
    self.start = start
    self.hasNext = hasNext
    self.isLoading = isLoading
  }
  
}

