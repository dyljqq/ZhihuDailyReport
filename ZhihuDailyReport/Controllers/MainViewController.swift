//
//  MainViewController.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/4/2.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: BaseViewController, NextPageLoadable {
  
  typealias DataType = Story
  
  let threshHold: CGFloat = 64
  
  var dataSource: [Story] = []
  
  var nextPageState: NextPageState = NextPageState()
  
  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: CGRect.zero)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.prefetchDataSource = self
    tableView.rowHeight = 60
    tableView.tableFooterView = UIView()
    tableView.backgroundColor = Color.background
    
    StoryCell.registerNib(tableView)
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    
    loadNext(start: 0, reloadView: tableView)
    
    tableView.addRefreshFooter { [weak self] refreshView in
      guard let strongSelf = self else { return }
      strongSelf.loadNext(start: strongSelf.nextPageState.start + 1, reloadView: strongSelf.tableView, refreshView: refreshView)
    }
  }
  
  func performLoad(successHandler: @escaping ([Story], Bool) -> (), failureHandler: @escaping (String) -> ()) {
    if nextPageState.start == 0 {
      send(router: Router.lastNews) { [weak self] (storyList: StoryList?) in
        guard let strongSelf = self else { return }
        guard let storyList = storyList else { return }
        
        successHandler(storyList.stories, true)
      }
    } else {
      send(router: Router.oldStories(Date.diff(day: -Double(nextPageState.start)))) { (storyList: StoryList?) in
        guard let storyList = storyList else { return }
        
        successHandler(storyList.stories, true)
      }
    }
  }
  
  private func setup() {
    title = "今日热文"
    
    view.backgroundColor = Color.background
    
    view.addSubview(tableView)
    
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    tableView.startObservingDirection()
  }
  
  deinit {
    tableView.stopObservingDirection()
  }

}

extension MainViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue() as StoryCell
    cell.render(story: dataSource[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
  }
  
}

extension MainViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}

extension MainViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    
  }
}
