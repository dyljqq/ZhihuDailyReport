//
//  Story.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/3/30.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Story {
  
  let id: Int
  let title: String
  let type: Int
  let image: String
  let images: [String]
  
  init(_ json: JSON) {
    self.id = json["id"].intValue
    self.title = json["title"].stringValue
    self.type = json["type"].intValue
    self.images = json["images"].arrayValue.compactMap { $0.stringValue }
    
    self.image = self.images.isEmpty ? json["image"].stringValue : (self.images.first ?? "")
  }
  
}

extension Story: Decodable {
  
  static func parse(data: JSON) -> Story {
    return Story(data)
  }
  
}
