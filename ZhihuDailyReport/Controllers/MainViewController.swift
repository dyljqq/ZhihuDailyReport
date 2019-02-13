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

fileprivate extension Selector {
  static let menu = #selector(MainViewController.menuItemTapped)
}

class MainViewController: BaseViewController {
  
  lazy var mainDataSource: MainStoryDataSource = {
    return MainStoryDataSource(bannerView: self.bannerView, tableView: self.tableView)
  }()
  
  let threshHold: CGFloat = screenWidth / 2
  
  lazy var titleView: TitleView = {
    let titleView = TitleView(frame: CGRect(x: 0, y: 0, width: 150, height: 25))
    return titleView
  }()
  
  lazy var bannerView: FSPagerView = {
    let bannerView = FSPagerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: threshHold))
    bannerView.isInfinite = true
    bannerView.automaticSlidingInterval = 5
    bannerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: FSPagerViewCell.className)
    return bannerView
  }()
  
  lazy var headerView: ParallaxHeaderView = {
    let headerView = ParallaxHeaderView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: threshHold), subView: self.bannerView)
    return headerView
  }()
  
  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: CGRect.zero)
    tableView.tableFooterView = UIView()
    tableView.backgroundColor = Color.background
    tableView.tableHeaderView = self.headerView
    tableView.showsVerticalScrollIndicator = false
    
    TitleCell.registerNib(tableView)
    StoryCell.registerNib(tableView)
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationItem.titleView = self.titleView
    setupNavigationBar(by: 0)
  }
  
  private func setup() {
    self.titleView.render(title: "今日热文")
    view.backgroundColor = Color.background
    
    setLeftNavigationItem()
    
    view.addSubview(tableView)
    
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    headerView.stopClosure = { [unowned self] maxOffsetY in
      self.tableView.contentOffset.y = maxOffsetY
    }
    
    mainDataSource.scrollViewDidScrollClosure = { [unowned self] scrollView, point in
      self.titleView.render(title: point?.title ?? "今日热文")
      let offsetY = scrollView.contentOffset.y
      if offsetY < 0 {
        if let headerView = self.tableView.tableHeaderView as? ParallaxHeaderView {
          headerView.layoutView(offset: scrollView.contentOffset)
        }
        let progress = -offsetY / (navigationBarHeight + 30)
        if progress > 0.01 && !self.mainDataSource.nextPageState.isLoading {
          self.titleView.showProgressView()
        } else {
          self.titleView.hideProgressView()
        }
        self.titleView.progress = Int(progress * 100)
      } else {
        self.setupNavigationBar(by: offsetY)
      }
    }
    
    mainDataSource.scrollViewDidEndDraggingClosure = { [unowned self] offsetY in
      let progress = -offsetY / (navigationBarHeight + 30)
      if progress >= 1 {
        self.titleView.showIndicatorView()
        self.mainDataSource.loadNext(start: 0)
      } else {
        self.titleView.hideProgressView()
      }
    }
    
    mainDataSource.cellSelectedClosure = { [weak self] story in
      guard let weakSelf = self else {
        return
      }
      print("story: \(story)")
      weakSelf.coordinator?.pushDetailStoryViewController(storyId: story.id)
    }
    
    mainDataSource.loadDataFinished = { [unowned self] in
      self.titleView.hideIndicatorView()
    }
    
  }
  
  private func setLeftNavigationItem() {
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(imageName: .iconMenuBlack), style: .plain, target: self, action: .menu)
  }
  
  @objc func menuItemTapped() {
    print("menu icon tapped")
  }
  
  deinit {}

}

fileprivate extension MainViewController {
  func setupNavigationBar(by offsetY: CGFloat) {
    let alpha = min(1, offsetY / (threshHold + navigationBarHeight))
    self.navigationController?.navigationBar.djsetBackgroundColor(backgroundColor: Color.navigation.withAlphaComponent(alpha))
  }
}
