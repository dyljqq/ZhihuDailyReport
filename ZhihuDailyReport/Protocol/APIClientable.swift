//
//  APIClient.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/3/30.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol APIClient {}

extension APIClient {
  
  func send<T: Decodable>(router: Router, completionHandler: @escaping (T?) -> ()) {
    Alamofire.request(router).validate().responseDecodableObject { (response: DataResponse<T>) in
      completionHandler(response.value)
    }
  }
  
}
