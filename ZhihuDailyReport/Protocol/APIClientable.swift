//
//  APIClientable.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/3/30.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol APIClientable {}

extension APIClientable {
  
  func send<T: Decodable>(router: Router, completionHandler: @escaping (T?) -> ()) {
    Alamofire.request(router).validate().responseJSON { response in
      switch response.result {
      case .success(let value):
        let json = JSON(value)
        completionHandler(T.parse(data: json))
      case .failure(let error):
        print("Request Error: \(error)")
        completionHandler(nil)
      }
    }
  }
  
}
