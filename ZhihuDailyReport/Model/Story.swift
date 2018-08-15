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
  let image: String
  let images: [String]
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = try container.decode(Int.self, forKey: .id)
    self.title = try container.decode(String.self, forKey: .title)
    self.type = try container.decode(Int.self, forKey: .type)
    if let images = try? container.decode([String].self, forKey: .images) {
      self.images = images
    } else {
      self.images = []
    }
    
    if let image = try? container.decode(String.self, forKey: .image) {
      self.image = image
    } else {
      self.image = self.images.first ?? ""
    }
  }
  
  private enum CodingKeys: String, CodingKey {
    case id
    case title
    case type
    case image
    case images
  }
  
}
