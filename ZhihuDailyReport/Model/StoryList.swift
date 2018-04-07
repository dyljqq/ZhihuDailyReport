//
//  StoryList.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/3/30.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import Foundation
import SwiftyJSON

struct StoryList {
  
  let date: String
  let stories: [Story]
  let topStories: [Story]
  
  init(_ json: JSON) {
    self.date = json["date"].stringValue
    self.stories = json["stories"].arrayValue.compactMap { Story($0) }
    self.topStories = json["top_stories"].arrayValue.compactMap { Story($0) }
  }
  
}

extension StoryList: Decodable {
  
  static func parse(data: JSON) -> StoryList {
    return StoryList(data)
  }
  
}
