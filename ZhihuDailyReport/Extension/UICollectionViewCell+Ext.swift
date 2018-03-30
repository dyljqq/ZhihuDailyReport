//
//  UICollectionViewCell+Ext.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/3/30.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
  
  class func registerClass(_ collectionView: UICollectionView) {
    collectionView.register(classForCoder(), forCellWithReuseIdentifier: className)
  }
  
  class func registerNib(_ collectionView: UICollectionView) {
    collectionView.register(nib, forCellWithReuseIdentifier: className)
  }
  
}
