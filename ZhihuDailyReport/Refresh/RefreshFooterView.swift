//
//  RefreshFooterView.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/4/2.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

class RefreshFooterView: RefreshView {
  
  let noMoreData = "没有更多数据"
  
  lazy var stateLabel: UILabel = {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 20))
    label.font = UIFont.systemFont(ofSize: 12)
    label.textAlignment = .center
    label.textColor = UIColor(red: 150/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1)
    return label
  }()
  
  lazy var arrowImageView: UIImageView = {
    let imageView = UIImageView(frame: CGRect.zero)
    imageView.image = UIImage(imageName: .pullArrow)
    return imageView
  }()
  
  lazy var activityView: UIActivityIndicatorView = {
    let activityView = UIActivityIndicatorView()
    activityView.activityIndicatorViewStyle = .gray
    activityView.isHidden = true
    return activityView
  }()
  
  override var refreshText: String {
    switch state {
    case .normal: return "上拉加载数据"
    case .pulling: return "松开可加载数据"
    case .loading: return "正在加载更多"
    case .end: return ""
    }
  }
  
  override var refreshWidth: CGFloat {
    let width = self.refreshText.size(font: UIFont.systemFont(ofSize: 12)).width
    return width
  }
  
  override func setup() {
    stateLabel.text = refreshText
    
    addSubview(stateLabel)
    addSubview(arrowImageView)
    addSubview(activityView)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    stateLabel.frame = CGRect(x: (bounds.width - refreshWidth) / 2, y: (bounds.height - 20) / 2, width: refreshWidth, height: 20)
    arrowImageView.frame = CGRect(x: (bounds.width - refreshWidth) / 2 - 26, y: (bounds.height - 32) / 2, width: 32, height: 32)
    activityView.frame = arrowImageView.frame
  }
  
  override func normalRefresh() {
    self.isHidden = false
    state = .normal
    stateLabel.text = refreshText
    
    arrowImageView.isHidden = false
    
    activityView.stopAnimating()
    activityView.isHidden = true
    
    guard let scrollView = scrollView else { return }
    UIView.animate(withDuration: 0.2, animations: {}, completion: { finished in
      UIView.animate(withDuration: 0.2, animations: {
        scrollView.contentInset = self.scrollViewOriginalEdgeInsets
      })
    })
  }
  
  override func pullingRefresh() {
    state = .pulling
    stateLabel.text = refreshText
    
    arrowImageView.isHidden = false
    
    activityView.isHidden = true
    
    UIView.animate(withDuration: 0.2, animations: {
      self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    })
  }
  
  override func loadingRefresh() {
    state = .loading
    stateLabel.text = refreshText
    
    activityView.isHidden = false
    arrowImageView.isHidden = true
    
    activityView.startAnimating()
    
    UIView.animate(withDuration: 0.2, animations: {
      var inset = self.scrollViewOriginalEdgeInsets
      inset.bottom += self.threshHold
      self.scrollView?.contentInset = inset
    }, completion: { finished in
      self.refreshHandler(self)
    })
  }
  
  override func scrollViewContentOffsetDidChange(scrollView: UIScrollView) {
    let realHeight = scrollView.frame.height - scrollViewOriginalEdgeInsets.top - scrollViewOriginalEdgeInsets.bottom
    let beyondScrollViewHeight = scrollView.contentSize.height - realHeight
    guard beyondScrollViewHeight > 0 else { return }
    
    let y = scrollView.contentOffset.y + scrollView.bounds.height - scrollViewOriginalEdgeInsets.top - scrollView.contentSize.height
    guard y > 0 else { return }
    
    if scrollView.isDragging {
      state = y >= threshHold ? .pulling : .normal
    } else {
      state = state == .pulling ? .loading : .normal
    }
  }
  
  func showNoMoreData() {
    stateLabel.text = "没有更多的数据"
    activityView.isHidden = true
    arrowImageView.isHidden = true
  }
  
}
