//
//  ParallaxHeaderView.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2019/2/11.
//  Copyright © 2019 dyljqq. All rights reserved.
//

import UIKit


class ParallaxHeaderView: UIView {
  
  let subView: UIView
  
  let maxOffsetY: CGFloat = -(navigationBarHeight + 30)
  
  var stopClosure: ((CGFloat) -> Void)?
  
  lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView(frame: self.bounds)
    scrollView.addSubview(self.subView)
    return scrollView
  }()
  
  init(frame: CGRect, subView: UIView) {
    self.subView = subView
    super.init(frame: frame)
    
    self.setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    subView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
    self.addSubview(self.scrollView)
  }
  
  func layoutView(offset: CGPoint) {
    let offsetY = offset.y
    if offsetY < maxOffsetY {
      stopClosure?(maxOffsetY)
    } else if (offsetY <= 0 && offsetY >= maxOffsetY) {
      var rect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height);
      rect.origin.y += offsetY
      rect.size.height -= offsetY
      scrollView.frame = rect
      scrollView.clipsToBounds = false
    }
  }
  
}
