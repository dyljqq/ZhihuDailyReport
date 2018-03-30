//
//  Reloadable.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/3/30.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

protocol Reloadable {
  func reloadData()
}

extension UITableView: Reloadable {}
extension UICollectionView: Reloadable {}
