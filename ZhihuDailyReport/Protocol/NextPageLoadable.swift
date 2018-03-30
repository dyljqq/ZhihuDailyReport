//
//  File.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/3/30.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

protocol NextPageLoadable: class {
  
  associatedtype DataType
  
  var data: [DataType] { get set }
  var nextPageState: NextPageState { get set }
  
  func performLoad(successHandler: @escaping (_ rows: [DataType], _ hasNext: Bool) -> (), failureHandler: @escaping (String) -> ())
  
}

extension NextPageLoadable {
  
  func loadNext(start: Int, reloadView: Reloadable) {
    guard nextPageState.hasNext else { return }
    guard nextPageState.isLoading else { return }
    
    nextPageState.update(start: start, hasNext: nextPageState.hasNext, isLoading: true)
    
    performLoad(successHandler: { [weak self] items, hasNext in
      
      guard let strongSelf = self else { return }
      
      if start == 0 {
        strongSelf.data.removeAll()
      }
      
      strongSelf.data.append(contentsOf: items)
      strongSelf.nextPageState.update(start: strongSelf.nextPageState.start, hasNext: hasNext, isLoading: false)
      reloadView.reloadData()
      
    }, failureHandler: { msg in
      
    })
  }
  
}
