//
//  DataRequest.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2018/8/15.
//  Copyright © 2018年 dyljqq. All rights reserved.
//

import Foundation
import Alamofire

extension DataRequest {
  
  private static func decodableObjectSerialize<T: Decodable>(_ decoder: JSONDecoder) -> DataResponseSerializer<T> {
    return DataResponseSerializer { _, response, data, error in
      if let error = error {
        return .failure(error)
      }
      return decodeToObject(decoder: decoder, response: response, data: data)
    }
  }
  
  private static func decodeToObject<T: Decodable>(decoder: JSONDecoder, response: HTTPURLResponse?, data: Data?) -> Result<T> {
    let result = Request.serializeResponseData(response: response, data: data, error: nil)
    
    switch result {
    case .success(let data):
      do {
        let object = try decoder.decode(T.self, from: data)
        return .success(object)
      } catch {
        return .failure(error)
      }
    case .failure(let error):
      return .failure(error)
    }
  }
  
  @discardableResult
  public func responseDecodableObject<T: Decodable>(queue: DispatchQueue? = nil, decoder: JSONDecoder = JSONDecoder(), completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return response(queue: queue, responseSerializer: DataRequest.decodableObjectSerialize(decoder), completionHandler: completionHandler)
  }
  
}
