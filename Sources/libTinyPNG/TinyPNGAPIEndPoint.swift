//
//  File.swift
//  
//
//  Created by joker on 2022/3/20.
//

import Foundation

/// [适配Linux Foundation](https://www.xknote.com/ask/611147cca0f56.html)
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// API核心定义
public enum TinyPNGAPIEndPoint: String {
    static let apiHostURL = URL(string: "https://api.tinify.com")
    case shrink
    var url: URL? {
        get {
            return TinyPNGAPIEndPoint.apiHostURL?.appendingPathComponent(self.rawValue)
        }
    }
    static var jsonDecoder: JSONDecoder {
        JSONDecoder()
    }
    static var jsonEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [
            .prettyPrinted,
            .sortedKeys,
            .withoutEscapingSlashes
        ]
        return encoder
    }
    static func makeRequest(for url: URL, with apiKey: String, httpMethod: String = "GET", httpBody: Data? = nil) throws -> URLRequest {
        
        guard let base64AuthroizationString = "api:\(apiKey)".data(using: .utf8)?.base64EncodedString() else {
            throw TinyPNGAPIError.wrongAuthorication
        }
        
        var request = URLRequest(url: url)
        let authorizationValue = "Basic \(base64AuthroizationString)"
        request.setValue(authorizationValue, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        return request
    }
    
    /// 跨Linux、MacOS平台网络请求处理
    /// [参考文章](https://diegolavalle.com/posts/2021-11-11-urlsession-concurrency-linux/)
    static func dataTask(for request: URLRequest) async throws -> (Data, URLResponse) {
#if canImport(FoundationNetworking)
        return try await withCheckedContinuation({ continuation in
            URLSession.shared.dataTask(with: request) { data, response, error in
                continuation.resume(returning: (data, response))
            }.resume()
        })
#else
        return try await URLSession.shared.data(for: request)
#endif
    }
}
