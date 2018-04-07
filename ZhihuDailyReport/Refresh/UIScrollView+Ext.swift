//
//  UIScrollView+Ext.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/4/2.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

enum UIScrollViewDirection {
  case up
  case down
  case left
  case right
}

private let scrollViewContentOffsetKey = "contentOffset"

extension UIScrollView {
  
  func startObservingDirection() {
    self.addObserver(self, forKeyPath: scrollViewContentOffsetKey, options: .new, context: nil)
  }
  
  func stopObservingDirection() {
    self.removeObserver(self, forKeyPath: scrollViewContentOffsetKey)
  }
  
  open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard let change = change, keyPath == scrollViewContentOffsetKey else { return }
    
    guard let newContentOffset = change[NSKeyValueChangeKey.newKey] as? CGPoint else { return }
    guard let oldContentOffset = change[NSKeyValueChangeKey.oldKey] as? CGPoint else { return }
    
    self.horizontalScrollingDirection = newContentOffset.x < oldContentOffset.x ? UIScrollViewDirection.left : UIScrollViewDirection.right
    self.verticalScrollingDirection = newContentOffset.y < oldContentOffset.y ? UIScrollViewDirection.up : UIScrollViewDirection.down
  }
  
}


private var verticalDirectionKey = "verticalDirectionKey"
private var horizontalDirectionKey = "horizontalDirectionKey"

extension UIScrollView {
  
  var horizontalScrollingDirection: UIScrollViewDirection {
    get {
      return (objc_getAssociatedObject(self, &horizontalDirectionKey) as? UIScrollViewDirection) ?? .right
    }
    
    set {
      objc_setAssociatedObject(self, &horizontalDirectionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  var verticalScrollingDirection: UIScrollViewDirection {
    get {
      return (objc_getAssociatedObject(self, &verticalDirectionKey) as? UIScrollViewDirection) ?? .down
    }
    
    set {
      objc_setAssociatedObject(self, &verticalDirectionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
}

// Pull & Refresh

extension UIScrollView {
  
  @discardableResult
  func addRefreshFooter(_ refreshHandler: @escaping (RefreshView) -> ()) -> RefreshFooterView {
    let footerView = RefreshFooterView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 60), threshHold: 60, refreshType: .footer, refreshHandler: refreshHandler)
    addSubview(footerView)
    return footerView
  }
}
