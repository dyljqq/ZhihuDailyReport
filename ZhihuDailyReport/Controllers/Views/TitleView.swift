//
//  TitleView.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2019/2/13.
//  Copyright © 2019 dyljqq. All rights reserved.
//

import UIKit
import SnapKit

class TitleView: UIView {
  
  var progress: Int = 0 {
    didSet {
      if progress > 100 {
        progress = 100
      } else if progress < 0 {
        progress = 0
      }
      progressView.setProgress(progress, animated: true)
    }
  }
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 18)
    return label
  }()
  
  lazy var progressView: CircleProgressView = {
    let progressView = CircleProgressView()
    progressView.layer.cornerRadius = 9
    progressView.layer.masksToBounds = true
    progressView.lineWidth = 2
    progressView.inset = 2
    progressView.isHidden = true
    return progressView
  }()
  
  lazy var indicatorView: UIActivityIndicatorView = {
    let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
    indicatorView.isHidden = true
    return indicatorView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  func render(title: String) {
    self.titleLabel.text = title
  }
  
  func showProgressView() {
    UIView.animate(withDuration: 0.3, animations: {
      self.progressView.isHidden = false
    })
  }
  
  func hideProgressView() {
    UIView.animate(withDuration: 0.3, animations: {
      self.progressView.isHidden = true
    })
  }
  
  func showIndicatorView() {
    self.progressView.isHidden = true
    UIView.animate(withDuration: 0.3, animations: {
      self.indicatorView.isHidden = false
    }, completion: { finished in
      self.indicatorView.startAnimating()
    })
  }
  
  func hideIndicatorView() {
    UIView.animate(withDuration: 0.3, animations: {
      self.progressView.isHidden = true
      self.indicatorView.isHidden = true
    }, completion: { _ in
      self.indicatorView.stopAnimating()
    })
  }
  
  private func setup() {
    backgroundColor = .clear
    
    addSubview(titleLabel)
    addSubview(progressView)
    addSubview(indicatorView)
    
    titleLabel.snp.makeConstraints { make in
      make.center.equalTo(self)
    }

    progressView.snp.makeConstraints { make in
      make.right.equalTo(titleLabel.snp.left).offset(-5)
      make.centerY.equalToSuperview()
      make.width.height.equalTo(18)
    }
    
    indicatorView.snp.makeConstraints { make in
      make.right.equalTo(titleLabel.snp.left).offset(-5)
      make.centerY.equalToSuperview()
      make.width.height.equalTo(18)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
