//
//  MainViewController.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/4/2.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit
import SnapKit
import FSPagerView

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
  
  let threshHold: CGFloat = screenWidth / 2
  
  var dataSource: [CellDataType] = []
  
  var nextPageState: NextPageState = NextPageState()
  var banners = [Story]()
  
  fileprivate var currentDataSource: (UITableViewDataSource & UITableViewDelegate)? {
    didSet {
      tableView.delegate = currentDataSource
      tableView.dataSource = currentDataSource
      tableView.reloadData()
    }
  }
  fileprivate var points = [TitlePoint]()
  
  lazy var bannerView: FSPagerView = {
    let bannerView = FSPagerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: threshHold))
    bannerView.isInfinite = true
    bannerView.delegate = self
    bannerView.dataSource = self
    bannerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: FSPagerViewCell.className)
    return bannerView
  }()
  
  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: CGRect.zero)
    tableView.tableFooterView = UIView()
    tableView.backgroundColor = Color.background
    tableView.tableHeaderView = self.bannerView
    tableView.showsVerticalScrollIndicator = false
    
    TitleCell.registerNib(tableView)
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setupNavigationBar(by: 0)
  }
  
  func performLoad(successHandler: @escaping ([CellDataType], Bool) -> (), failureHandler: @escaping (String) -> ()) {
    if nextPageState.start == 0 {
      send(router: Router.lastNews) { [weak self] (storyList: StoryList?) in
        guard let strongSelf = self else { return }
        guard let storyList = storyList else { return }
        
        strongSelf.banners = storyList.topStories
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
    title = "今日热文"
    
    view.backgroundColor = Color.background
    
    if #available(iOS 11, *) {
      tableView.contentInsetAdjustmentBehavior = .never
    }
    view.addSubview(tableView)
    
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    setDataSource()
  }
  
  func setDataSource() {
    let cellFactory: (CellDataType) -> (UITableViewCell) = { [unowned self] type in
      switch type {
      case .title(let title):
        let cell = self.tableView.dequeue() as TitleCell
        cell.render(text: title)
        return cell
      case .story(let story):
        let cell = self.tableView.dequeue() as StoryCell
        cell.render(story: story)
        return cell
      }
    }
    let cellHeightClosure: (CellDataType) -> (CGFloat) = { type in
      return type.height
    }
    let dataSource = ListDataSource<CellDataType>(items: self.dataSource, cellFactory: cellFactory, cellHeightClosure: cellHeightClosure)
    dataSource.scrollViewDidScrollClosure = { [unowned self] scrollView in
      self.setupNavigationBar(by: scrollView.contentOffset.y)
    }
    currentDataSource = dataSource
  }
  
  deinit {}

}

extension MainViewController: FSPagerViewDataSource {
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

extension MainViewController: FSPagerViewDelegate {
  func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
    pagerView.deselectItem(at: index, animated: true)
    // TODO
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
  
  func setupNavigationBar(by offsetY: CGFloat) {
    let alpha = min(1, offsetY / (threshHold + navigationBarHeight))
    self.navigationController?.navigationBar.lk_setBackgroundColor(backgroundColor: Color.main.withAlphaComponent(alpha))
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
