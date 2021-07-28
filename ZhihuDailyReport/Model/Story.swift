//
//  Story.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/3/30.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import Foundation

struct Story: Decodable {
  
  var id: Int
  var title: String
  var type: Int
  var hint: String

  var image: String?
  var images: [String]?
  
  var imageUrl: String {
    return self.image ?? self.images?.first ?? ""
  }
  
}

