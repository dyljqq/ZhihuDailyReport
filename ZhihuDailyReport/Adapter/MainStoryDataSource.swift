//
//  MainStoryDataSource.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/5/29.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit
import FSPagerView
import Kingfisher

class MainStoryDataSource: NSObject, NextPageLoadable, APIClient {
  
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
  
  let bannerView: FSPagerView
  let tableView: UITableView
  
  var banners = [TopStory]()
  var nextPageState: NextPageState = NextPageState()
  
  var dataSource: [DataType] = []
  
  var scrollViewDidScrollClosure: ((UIScrollView) -> ())?
  
  fileprivate var points: [TitlePoint] = []
  
  init(bannerView: FSPagerView, tableView: UITableView) {
    self.bannerView = bannerView
    self.tableView = tableView
    super.init()
    
    self.setup()
  }
  
  func loadNext(start: Int) {
    loadNext(start: start, reloadView: tableView)
  }
  
  func performLoad(successHandler: @escaping ([DataType], Bool) -> (), failureHandler: @escaping (String) -> ()) {
    if nextPageState.start == 0 {
      send(router: Router.lastNews) { [weak self] (storyList: StoryList?) in
        guard let strongSelf = self else { return }
        guard let storyList = storyList else { return }

        strongSelf.banners = storyList.topStories ?? []
        strongSelf.bannerView.reloadData()

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
    if #available(iOS 11, *) {
      tableView.contentInsetAdjustmentBehavior = .never
    }
    
    bannerView.delegate = self
    bannerView.dataSource = self
    
    tableView.delegate = self
    tableView.dataSource = self
    
    if #available(iOS 10.0, *) {
      tableView.prefetchDataSource = self
    }
 
    tableView.addRefreshFooter { [weak self] refreshView in
      guard let strongSelf = self else { return }
      strongSelf.loadNext(start: strongSelf.nextPageState.start + 1, reloadView: strongSelf.tableView, refreshView: refreshView)
    }
    
    loadNext(start: 0)
  }
  
}

extension MainStoryDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let type = dataSource[indexPath.row]
    switch type {
    case .title:
      return tableView.dequeue() as TitleCell
    case .story:
      return tableView.dequeue() as StoryCell
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let type = dataSource[indexPath.row]
    switch type {
    case .title(let title):
      (cell as? TitleCell)?.render(text: title)
    case .story(let story):
      (cell as? StoryCell)?.render(story: story)
    }
  }
}

extension MainStoryDataSource: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return dataSource[indexPath.row].height
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension MainStoryDataSource: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    let urls: [URL] = indexPaths.compactMap { indexPath in
      if case DataType.story(let story) = self.dataSource[indexPath.row] {
        return URL(string: story.image)
      }
      return nil
    }
    ImagePrefetcher(urls: urls).start()
  }
}

extension MainStoryDataSource: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if let closure = scrollViewDidScrollClosure {
      closure(scrollView)
    }
  }
}

extension MainStoryDataSource: FSPagerViewDataSource {
  func numberOfItems(in pagerView: FSPagerView) -> Int {
    return banners.count
  }
  
  func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
    let cell = pagerView.dequeueReusableCell(withReuseIdentifier: FSPagerViewCell.className, at: index)
    let banner = banners[index]
    cell.imageView?.clipsToBounds = true
    cell.imageView?.contentMode = .scaleAspectFill
    cell.imageView?.kf.setImage(with: URL(string: banner.image))
    return cell
  }
}

extension MainStoryDataSource: FSPagerViewDelegate {
  func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
    pagerView.deselectItem(at: index, animated: true)
    // TODO
  }
}

extension MainStoryDataSource {
  
  func config(storyList: StoryList, isStart: Bool = false) -> [DataType] {
    var dataSource = storyList.stories.map { DataType.story($0) }
    
    if !isStart {
      dataSource.insert(DataType.title(storyList.date.title), at: 0)
    }
    
    var start: CGFloat = 0
    var end: CGFloat = 0
    self.dataSource.forEach { start += $0.height }
    dataSource.forEach { end += $0.height }
    let point = TitlePoint(start: start, end: start + end, title: isStart ? "今日热文" : storyList.date.title)
    points.append(point)
    
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
