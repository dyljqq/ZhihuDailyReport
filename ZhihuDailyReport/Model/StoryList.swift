//
//  StoryList.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/3/30.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import Foundation
import SwiftyJSON

struct StoryList: Decodable {
  
  let date: String
  let stories: [Story]
  var topStories: [Story]?
  
}
