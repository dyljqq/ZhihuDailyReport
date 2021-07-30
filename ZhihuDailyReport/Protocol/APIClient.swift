//
//  APIClient.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/3/30.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import Foundation
import Alamofire

protocol Client {
    
    func send<T: Decodable>(router: Router, completionHandler: @escaping (T?) -> ())
    
}

struct APIClient: Client {
    
  static let shared = APIClient()
  
  let decoder = JSONDecoder()
  
  init() {
      decoder.keyDecodingStrategy = .convertFromSnakeCase
  }
  
  func send<T: Decodable>(router: Router, completionHandler: @escaping (T?) -> ()) {
    AF.request(router).validate().responseDecodable(of: T.self, decoder: decoder) { data in
      guard let value = data.value else { return }
      completionHandler(value)
    }
  }
  
}
