//
//  MainStoryDataSource.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/5/29.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

class MainStoryDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
  
  enum CellDataType {
    case title(String)
    case story(Story)
    
    var height: CGFloat {
      switch self {
      case .title: return 30
      case .story: return 60
      }
    }
  }
  
  let items: [CellDataType]
  
  var scrollViewDidScrollClosure: ((UIScrollView) -> ())?
  
  init(items: [CellDataType]) {
    self.items = items
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let type = items[indexPath.row]
    switch type {
    case .title(let title):
      let cell = tableView.dequeue() as TitleCell
      cell.render(text: title)
      return cell
    case .story(let story):
      let cell = tableView.dequeue() as StoryCell
      cell.render(story: story)
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return items[indexPath.row].height
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
