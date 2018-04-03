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
  
  fileprivate struct TitlePoint {
    let start: CGFloat
    let end: CGFloat
    let title: String
    
    var description: String {
      return "start：\(start), end: \(end), title: \(title)"
    }
  }
  
  typealias DataType = CellDataType
  
  let threshHold: CGFloat = 64
  
  var dataSource: [CellDataType] = []
  
  var nextPageState: NextPageState = NextPageState()
  
  fileprivate var points = [TitlePoint]()
  
  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: CGRect.zero)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.prefetchDataSource = self
    tableView.tableFooterView = UIView()
    tableView.backgroundColor = Color.background
    tableView.showsVerticalScrollIndicator = false
    
    TitleCell.registerNib(tableView)
    StoryCell.registerNib(tableView)
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    
    navigationController?.navigationBar.isTranslucent = false
    loadNext(start: 0, reloadView: tableView)
    
    tableView.addRefreshFooter { [weak self] refreshView in
      guard let strongSelf = self else { return }
      strongSelf.loadNext(start: strongSelf.nextPageState.start + 1, reloadView: strongSelf.tableView, refreshView: refreshView)
    }
  }
  
  func performLoad(successHandler: @escaping ([CellDataType], Bool) -> (), failureHandler: @escaping (String) -> ()) {
    if nextPageState.start == 0 {
      send(router: Router.lastNews) { [weak self] (storyList: StoryList?) in
        guard let strongSelf = self else { return }
        guard let storyList = storyList else { return }
        
        successHandler(strongSelf.config(storyList: storyList, isStart: true), true)
        strongSelf.loadNext(start: strongSelf.nextPageState.start + 1, reloadView: strongSelf.tableView)
      }
    } else {
      send(router: Router.oldStories(Date.diff(day: -Double(nextPageState.start - 1)))) { [weak self] (storyList: StoryList?) in
        guard let strongSelf = self else { return }
        guard let storyList = storyList else { return }
        
        successHandler(strongSelf.config(storyList: storyList), true)
      }
    }
  }
  
  private func setup() {
    title = "今日热文"
    
    view.backgroundColor = Color.background
    
    if #available(iOS 11, *) {
      tableView.contentInsetAdjustmentBehavior = .never
    }
    view.addSubview(tableView)
    
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  deinit {}

}

extension MainViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let type = dataSource[indexPath.row]
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
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return dataSource[indexPath.row].height
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

extension MainViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
  }
  
}

fileprivate extension MainViewController {
  func config(storyList: StoryList, isStart: Bool = false) -> [CellDataType] {
    var dataSource = storyList.stories.map { CellDataType.story($0) }
    
    if !isStart {
      dataSource.insert(CellDataType.title(storyList.date.title), at: 0)
    }
    
    var start: CGFloat = 0
    var end: CGFloat = 0
    self.dataSource.forEach { start += $0.height }
    dataSource.forEach { end += $0.height }
    let point = TitlePoint(start: start, end: start + end, title: isStart ? "今日热文" : storyList.date.title)
    points.append(point)
    
    points.forEach { print($0.description) }

    return dataSource
  }
}

fileprivate extension String {
  
  var title: String {
    guard let date = Date.to(dateString: self) else { return self }
    
    let calendar = Calendar.current
    let components = calendar.dateComponents(Set<Calendar.Component>([.month, .day, .weekday]), from: date)
    guard let month = components.month, let day = components.day, let weekday = components.weekday, let week = Week(rawValue: weekday) else { return self }
    return "\(month)月\(day)日 \(week.name)"
  }
}

fileprivate enum Week: Int {
  case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
  
  var name: String {
    switch self {
    case .sunday: return "星期天"
    case .monday: return "星期一"
    case .tuesday: return "星期二"
    case .wednesday: return "星期三"
    case .thursday: return "星期四"
    case .friday: return "星期五"
    case .saturday: return "星期六"
    }
  }
}
