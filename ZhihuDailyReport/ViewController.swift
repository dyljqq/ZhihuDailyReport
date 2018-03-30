//
//  ViewController.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/3/30.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {
  
  var count = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func resetAction(_ sender: Any) {
    count = 0
    send(router: Router.lastNews, completionHandler: { (storyList: StoryList?) in
      guard let storyList = storyList else { return }
      print("last news: \(storyList)")
    })
  }
  
  @IBAction func nextAction(_ sender: Any) {
    count += 1
    send(router: Router.oldStories(Date.diff(day: 1))) { (storyList: StoryList?) in
      guard let storyList = storyList else { return }
      print("day: \(self.count), old stories: \(storyList)")
    }
  }
  
}

