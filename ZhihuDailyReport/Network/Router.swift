//
//  Router.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/3/30.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import Foundation
import Alamofire

enum Router {
  case lastNews
  case oldStories(String)
}

extension Router: URLRequestConvertible {

  static let baseURL = "https://news-at.zhihu.com/api/7"
  
  var method: HTTPMethod {
    return .get
  }
  
  var headers: [String: String] {
    return [
      "method": "GET",
      "scheme": "https",
      "path": "/api/7/stories/latest?client=0",
      "authority": "news-at.zhihu.com",
      "x-uuid": "E5A84E84-22C1-4FAE-B394-6473BAAA3877",
      "authorization": "Bearer cuEiErBwQiCkwNzT1aVE_g",
      "x-device": "iPhone11,6/D331pAP",
      "x-os": "iOS 13.3.1",
      "x-device-token": "c052f56762a9cae329780435fe736635d6bd3c322907bbaa30a14ac17f96362b",
      "user-agent": "zhi hu ri bao/3.1.0 (iPhone; iOS 13.3.1; Scale/3.00)",
      "x-app-version": "3.1.0",
      "cookie": "KLBRSID=031b5396d5ab406499e2ac6fe1bb1a43|1587486610|1587485789; _xsrf=iUMf1qXbb19xJKg9XLJdYyaoawtUgkQe; q_c1=a7941c0f18e947dbbae7ed21ca1e65f7|1570701192000|1570701192000; _zap=14c8e7bb-77c3-4ed4-9550-c6f17473e3ca; Hm_lvt_98beee57fd2ef70ccdd5ca52b9740c49=1587484166; d_c0=ADACiGMQoAtNBSBm5cYlHmEgKUUYvFlCemo=|1587485790",
      "x-b3-traceid": "BC9EF1E6959A4192",
      "x-b3-spanid": "BC9EF1E6959A4192",
      "accept-language": "zh-Hans-CN;q=1",
      "x-bundle-id": "com.zhihu.daily",
      "x-api-version": "7",
    ]
  }
  
  var parameters: [String: Any] {
    return [:]
  }
  
  var path: String {
    switch self {
    case .lastNews: return "/stories/latest"
    case .oldStories(let dateString): return "/stories/before/" + dateString
    }
  }
  
  func asURLRequest() throws -> URLRequest {
    let url = try Router.baseURL.asURL()
    var request = URLRequest(url: url.appendingPathComponent(path))
    print("url: \(request.url?.absoluteString)")
    request.httpMethod = method.rawValue
    request.allHTTPHeaderFields = headers
    request.timeoutInterval = TimeInterval(10 * 1000)
    return try URLEncoding.default.encode(request, with: parameters)
  }
  
}
