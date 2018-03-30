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
  
  static let baseURL = "http://news-at.zhihu.com/api/4/"
  
  var method: HTTPMethod {
    return .get
  }
  
  var headers: [String: String] {
    return [:]
  }
  
  var parameters: [String: Any] {
    return [:]
  }
  
  var path: String {
    switch self {
    case .lastNews: return "news/latest"
    case .oldStories(let dateString): return "news/before/" + dateString
    }
  }
  
  func asURLRequest() throws -> URLRequest {
    let url = try Router.baseURL.asURL()
    var request = URLRequest(url: url.appendingPathComponent(path))
    request.httpMethod = method.rawValue
    request.allHTTPHeaderFields = headers
    request.timeoutInterval = TimeInterval(10 * 1000)
    return try URLEncoding.default.encode(request, with: parameters)
  }
  
}
