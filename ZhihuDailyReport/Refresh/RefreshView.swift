//
//  RefreshView.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/4/2.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

extension String {
  func size(font: UIFont, width: CGFloat = CGFloat.greatestFiniteMagnitude, height: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
    return self.boundingRect(with: CGSize(width: width, height: height), context: nil).size
  }
}

class RefreshView: UIView, Refreshable {
    
  var state: RefreshState = .normal {
    didSet {
      guard state != oldValue else { return }
      switch state {
      case .normal:
        self.normalRefresh()
      case .pulling:
        self.pullingRefresh()
      case .loading:
        self.loadingRefresh()
      case .end: break
      }
    }
  }
  
  let threshHold: CGFloat
  let refreshType: RefreshViewType
  let refreshHandler: (RefreshView) -> ()
  
  var scrollView: UIScrollView?
  var refreshText: String { return "" }
  var refreshWidth: CGFloat { return 0 }
  var scrollViewOriginalEdgeInsets = UIEdgeInsets.zero
  
  required init(frame: CGRect, threshHold: CGFloat = 60, refreshType: RefreshViewType, refreshHandler: @escaping (RefreshView) -> ()) {
    self.threshHold = threshHold
    self.refreshType = refreshType
    self.refreshHandler = refreshHandler
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)
    
    removeObserver()
    guard let newSuperview = newSuperview as? UIScrollView else { return }
    scrollView = newSuperview
    scrollViewOriginalEdgeInsets = newSuperview.contentInset
    addObserver()
  }
  
  func endRefresh() {
    state = .normal
  }
  
  func setup() {
    
  }
  
  func normalRefresh() {
    
  }
  
  func pullingRefresh() {
    
  }
  
  func loadingRefresh() {
    
  }
  
  func scrollViewContentOffsetDidChange(scrollView: UIScrollView) {
    
  }
}

fileprivate var refreshContextKey = "refreshContextKey"

fileprivate var contentOffsetKey = #keyPath(UIScrollView.contentOffset)
fileprivate var contentSizeKey = #keyPath(UIScrollView.contentSize)
fileprivate var contentInsetKey = #keyPath(UIScrollView.contentInset)

extension RefreshView {
  
  func addObserver() {
    guard let scrollView = scrollView else { return }
    scrollView.addObserver(self, forKeyPath: contentSizeKey, options: .new, context: &refreshContextKey)
    scrollView.addObserver(self, forKeyPath: contentInsetKey, options: .new, context: &refreshContextKey)
    scrollView.addObserver(self, forKeyPath: contentOffsetKey, options: .new, context: &refreshContextKey)
  }
  
  func removeObserver() {
    guard let scrollView = scrollView else { return }
    scrollView.removeObserver(self, forKeyPath: contentSizeKey)
    scrollView.removeObserver(self, forKeyPath: contentInsetKey)
    scrollView.removeObserver(self, forKeyPath: contentOffsetKey)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard context == &refreshContextKey else { return }
    guard let scrollView = scrollView else { return }
    
    if keyPath == contentSizeKey && refreshType != .header {
      self.frame.origin.y = max(scrollView.frame.height, scrollView.contentSize.height)
    } else if keyPath == contentOffsetKey {
      if state != .loading {
        scrollViewContentOffsetDidChange(scrollView: scrollView)
      }
    } else if keyPath == contentInsetKey {
      if state != .loading {
        scrollViewOriginalEdgeInsets = scrollView.contentInset
      }
    }
  }
  
}
