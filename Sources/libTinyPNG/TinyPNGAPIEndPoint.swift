//
//  File.swift
//  
//
//  Created by joker on 2022/3/20.
//

import Foundation

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
}
