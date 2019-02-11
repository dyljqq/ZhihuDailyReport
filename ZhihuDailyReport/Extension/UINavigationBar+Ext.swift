//
//  UINavigationBar+Ext.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/4/7.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

private var overlayKey = "overlayKey"
private var translucentKey = "translucentKey"
private var colorKey = "colorKey"
private var backInIndicatorKey = "backInIndicatorLey"

extension UINavigationBar {
  
  var overlay: UIView? {
    get {
      return objc_getAssociatedObject(self, &overlayKey) as? UIView
    }
    set {
      objc_setAssociatedObject(self, &overlayKey, newValue as UIView?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  var translucent: Bool? {
    get {
      return objc_getAssociatedObject(self, &translucentKey) as? Bool
    }
    set {
      objc_setAssociatedObject(self, &translucentKey, newValue as Bool?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  var color: UIColor? {
    get {
      return objc_getAssociatedObject(self, &colorKey) as? UIColor
    }
    set {
      objc_setAssociatedObject(self, &colorKey, newValue as UIColor?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  var backInIndicator: UIButton? {
    get {
      return objc_getAssociatedObject(self, &backInIndicatorKey) as? UIButton
    }
    set {
      objc_setAssociatedObject(self, &backInIndicatorKey, newValue as UIButton?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

extension UINavigationBar {
  func djsetTitleColor(color: UIColor) {
    self.titleTextAttributes = [NSAttributedStringKey.foregroundColor: color]
  }
  
  func djsetBackgroundColor(backgroundColor: UIColor) {
    if overlay == nil {
      translucent = self.isTranslucent
      color = self.backgroundColor

      self.shadowImage = UIImage()
      self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
      self.isTranslucent = true
      self.backgroundColor = UIColor.clear
      
      overlay = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: navigationBarHeight))
      overlay?.autoresizingMask = UIViewAutoresizing.flexibleWidth
      if subviews.count > 0 {
        subviews.first?.insertSubview(overlay!, at: 0)
      } else {
        self.insertSubview(overlay!, at: 0)
      }
    }
    overlay?.backgroundColor = backgroundColor
  }
  
  func handleBackAction() {
    let _ = mainNavigationController.popViewController(animated: true)
  }
  
  func djsetTranslationY(translationY: CGFloat) {
    transform = CGAffineTransform(translationX: 0, y: translationY)
  }
  
  func djsetElementAlpha(alpha: CGFloat) {
    for (_, element) in subviews.enumerated() {
      if #available(iOS 11.0, *) {
        if element.isKind(of: NSClassFromString("_UINavigationBarLargeTitleView") as! UIView.Type) ||
          element.isKind(of: NSClassFromString("_UINavigationBarContentView") as! UIView.Type) ||
          element.isKind(of: NSClassFromString("_UINavigationBarModernPromptView") as! UIView.Type) {
          element.alpha = alpha
        }
      } else {
        if element.isKind(of: NSClassFromString("UINavigationItemView") as! UIView.Type) ||
          element.isKind(of: NSClassFromString("UINavigationButton") as! UIButton.Type) ||
          element.isKind(of: NSClassFromString("UINavBarPrompt") as! UIView.Type) {
          element.alpha = alpha
        }
        
        if element.isKind(of: NSClassFromString("_UINavigationBarBackIndicatorView") as! UIView.Type) {
          element.alpha = alpha
        }
      }
    }
    
    items?.forEach({ item in
      if let titleView = item.titleView {
        titleView.alpha = alpha
      }
      for barButtonItems in [item.leftBarButtonItems, item.rightBarButtonItems] {
        barButtonItems?.forEach({ item in
          if let customView = item.customView {
            customView.alpha = alpha
          }
        })
      }
    })
  }
  
  func djreset() {
    djsetElementAlpha(alpha: 1.0)
    setBackgroundImage(nil, for: UIBarMetrics.default)
    overlay?.removeFromSuperview()
    overlay = nil
    backInIndicator = nil
    self.isTranslucent = translucent ?? false
    self.backgroundColor = color ?? UIColor.clear
    tintColor = UIColor.white
  }
}
