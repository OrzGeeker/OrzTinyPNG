//
//  File.swift
//  
//
//  Created by joker on 2022/3/19.
//

import Foundation

/// TinyPNG API
///
/// [TinyPNG API Reference](https://tinypng.com/developers/reference)
public struct TinyPNGAPI {
    
    /// 存入API Key
    let apiKey: String
    
    /// 实始化必须传入API Key
    public init(apiKey key: String) {
        apiKey = key
    }
}



