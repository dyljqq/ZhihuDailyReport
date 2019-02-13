//
//  Weidget.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2019/2/13.
//  Copyright © 2019 dyljqq. All rights reserved.
//

import UIKit

private func angleToRadian(angle: Double)-> CGFloat {
  return CGFloat(angle / Double(180.0) * Double.pi)
}

class CircleProgressView: UIView {
  
  var inset: CGFloat = 5.0
  var lineWidth: CGFloat = 5.0
  
  var backgroundCircleColor = UIColor.lightGray
  var progressColor = UIColor.white
  
  var preProgress: Int = 0
  
  var progess: Int = 0 {
    didSet {
      if progess > 100 {
        progess = 100
      } else if progess < 0 {
        progess = 0
      }
    }
  }
  
  private var path = UIBezierPath()
  
  private lazy var progressLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.frame = self.bounds
    layer.fillColor = UIColor.clear.cgColor
    layer.strokeColor = progressColor.cgColor
    layer.lineWidth = lineWidth
    layer.path = self.path.cgPath
    layer.strokeStart = 0
    layer.strokeEnd = 1.0
    return layer
  }()
  
  private lazy var backgroundLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.frame = self.bounds
    layer.fillColor = UIColor.clear.cgColor
    layer.strokeColor = backgroundCircleColor.cgColor
    layer.lineWidth = lineWidth
    layer.path = self.path.cgPath
    layer.strokeStart = 0
    layer.strokeEnd = 1.0
    return layer
  }()
  
  init() {
    super.init(frame: CGRect.zero)
  }
  
  func setProgress(_ progress: Int, animated anim: Bool) {
    if anim {
      setProgress(progress, withDuration: 0.6)
    } else {
      self.progressLayer.strokeEnd = CGFloat(progress) / 100.0
    }
  }
  
  private func setProgress(_ progress: Int, withDuration duration: CGFloat) {
    self.progess = progress
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.duration = CFTimeInterval(duration)
    animation.fromValue = CGFloat(preProgress) / 100.0
    animation.toValue = CGFloat(progress) / 100.0
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    
    self.progressLayer.strokeEnd = CGFloat(progress) / 100.0
    self.progressLayer.add(animation, forKey: "animateCircleProgress")
    
    self.preProgress = progress
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()

    path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: bounds.width / 2, startAngle: angleToRadian(angle: -90), endAngle: angleToRadian(angle: 270), clockwise: true)
    layer.addSublayer(self.backgroundLayer)
    layer.addSublayer(self.progressLayer)
    
    setProgress(0, animated: true)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
