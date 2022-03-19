//
//  File.swift
//  
//
//  Created by joker on 2022/3/20.
//

import Foundation

/// API错误处理
public enum TinyPNGAPIError: Error {
    case invalidImageURL
    case invalidEndpointURL
    case wrongAuthorication
    case responseFailed
    case downloadImageFailed
    case resizeImageFailed
}
