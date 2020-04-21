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
  
  var id: Int
  var title: String
  var type: Int
  var hint: String
  var image: String?
  var images: [String]?
  
  var imageUrl: String {
    if let image = self.image {
      return image
    }
    return self.images?.first ?? ""
  }
  
}

