//
//  SimpleDataSource.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/5/28.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

class ListDataSource<T>: NSObject, UITableViewDataSource, UITableViewDelegate {
  
  fileprivate let items: [T]
  
  let cellFactory: (T) -> (UITableViewCell)
  let cellHeightClosure: ((T) -> (CGFloat))?
  
  var scrollViewDidScrollClosure: ((UIScrollView) -> ())?
  
  init(items: [T], cellFactory: @escaping (T) -> (UITableViewCell), cellHeightClosure: ((T) -> (CGFloat))? = nil) {
    self.items = items
    self.cellFactory = cellFactory
    self.cellHeightClosure = cellHeightClosure
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return self.cellFactory(items[indexPath.row])
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let closure = self.cellHeightClosure else {
      return 44.0
    }
    return closure(items[indexPath.row])
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if let closure = scrollViewDidScrollClosure {
      closure(scrollView)
    }
  }
}
