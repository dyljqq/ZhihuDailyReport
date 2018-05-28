//
//  File.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/3/30.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

typealias TableViewable = (UITableViewDataSource & UITableViewDelegate)

protocol NextPageLoadable: class {
  
  associatedtype DataType
  
  var dataSource: [DataType] { get set }
  var nextPageState: NextPageState { get set }
  
  func setDataSource()
  func performLoad(successHandler: @escaping (_ rows: [DataType], _ hasNext: Bool) -> (), failureHandler: @escaping (String) -> ())
  
}

extension NextPageLoadable {
  
  func loadNext(start: Int, reloadView: Reloadable, refreshView: RefreshView? = nil) {
    guard nextPageState.hasNext else { return }
    guard !nextPageState.isLoading else { return }
    
    nextPageState.update(start: start, hasNext: nextPageState.hasNext, isLoading: true)
    
    performLoad(successHandler: { [weak self] items, hasNext in
      guard let strongSelf = self else { return }
      refreshView?.endRefresh()
      
      if start == 0 {
        strongSelf.dataSource.removeAll()
      }
      
      strongSelf.dataSource.append(contentsOf: items)
      strongSelf.nextPageState.update(start: strongSelf.nextPageState.start, hasNext: hasNext, isLoading: false)
      strongSelf.setDataSource()
      
    }, failureHandler: { msg in
      
    })
  }
  
}
