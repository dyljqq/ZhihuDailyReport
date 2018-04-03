//
//  Refreshable.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/4/2.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

enum RefreshViewType {
  case header, footer
}

enum RefreshState {
  case normal, pulling, loading, end
}

protocol Refreshable {
  var state: RefreshState { get set }
  
  func normalRefresh()
  func pullingRefresh()
  func loadingRefresh()
  
  func scrollViewContentOffsetDidChange(scrollView: UIScrollView)
}
