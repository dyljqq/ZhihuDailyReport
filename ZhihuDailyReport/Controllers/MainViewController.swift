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
  
  lazy var bannerView: FSPagerView = {
    let bannerView = FSPagerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: threshHold))
    bannerView.isInfinite = true
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
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setupNavigationBar(by: 0)
  }
  
  private func setup() {
    title = "今日热文"
    
    view.backgroundColor = Color.background
    
    setLeftNavigationItem()
    
    view.addSubview(tableView)
    
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    mainDataSource.scrollViewDidScrollClosure = { [unowned self] scrollView in
      self.setupNavigationBar(by: scrollView.contentOffset.y)
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
    self.navigationController?.navigationBar.lk_setBackgroundColor(backgroundColor: Color.navigation.withAlphaComponent(alpha))
  }
}
