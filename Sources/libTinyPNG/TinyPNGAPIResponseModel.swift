//
//  File.swift
//  
//
//  Created by joker on 2022/3/20.
//

import Foundation

public struct TinyPNGAPIResponseModel: Codable {
    public let input: Input
    public let output: Output
    
    public struct Input: Codable {
        public let size: Int
        public let type: String
    }
    
    public struct Output: Codable {
        public let size: Int
        public let type: String
        public let width: Int
        public let height: Int
        public let ratio: Float
        public let url: URL
    }
    
    public var description: String? {
        guard let data = try? TinyPNGAPIEndPoint.jsonEncoder.encode(self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}
