//
//  Story.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/3/30.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Story: Decodable {
  
  let id: Int
  let title: String
  let type: Int
  var images: [String] = []
  
  var image: String {
    return images.first ?? ""
  }
  
}

struct TopStory: Decodable {
  let id: Int
  let title: String
  let type: Int
  let image: String
}
