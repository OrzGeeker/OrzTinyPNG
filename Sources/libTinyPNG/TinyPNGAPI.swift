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
    private let apiKey: String
    
    /// 实始化必须传入API Key
    public init(apiKey key: String) {
        apiKey = key
    }
    
    /// 压缩图片
    /// - Parameter url: 文件URL或者网络图片URL
    func compress(url: URL?) async throws -> (TinyPNGAPIError?, EndPoint.ResponseModel?) {
        guard let imageURL = url else {
            return (.invalidImageURL, nil)
        }
        
        guard let enpointURL = EndPoint.shrink.url else {
            throw TinyPNGAPIError.invalidEndpointURL
        }
        
        let source = EndPoint.RequestModel.Source(url: imageURL.absoluteString)
        let reqModel = EndPoint.RequestModel(source: source, resize: nil)
        let request = try EndPoint.makeRequest(for: enpointURL, with: apiKey, httpMethod: "POST", httpBody: reqModel.data)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            return (.responseFailed, nil)
        }
        let ret = try EndPoint.jsonDecoder.decode(EndPoint.ResponseModel.self, from: data)
        return (nil, ret)
    }
    
    /// 下载压缩后的图片
    /// - Parameter url: 压缩后的图片URL
    /// - Returns: 图片二进制数据
    func download(url: URL) async throws -> Data {
        let request = try EndPoint.makeRequest(for: url, with: apiKey)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw TinyPNGAPIError.downloadImageFailed
        }
        return data
    }
    
    /// 缩放经压缩后的图片
    /// - Parameters:
    ///   - url: 压缩后的图片URL
    ///   - resizeModel: 缩放参数设置模型
    /// - Returns: 经缩放处理后的图片二进制数据
    func resize(for url: URL, resizeModel: EndPoint.RequestModel.Resize) async throws -> Data {
        let reqModel = EndPoint.RequestModel(source: nil, resize: resizeModel)
        let request = try EndPoint.makeRequest(for: url, with: apiKey, httpMethod: "POST", httpBody: reqModel.data)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw TinyPNGAPIError.resizeImageFailed
        }
        return data
    }
}

public extension TinyPNGAPI {
    
    /// API错误处理
    enum TinyPNGAPIError: Error {
        case invalidImageURL
        case invalidEndpointURL
        case wrongAuthorication
        case responseFailed
        case downloadImageFailed
        case resizeImageFailed
    }
    
    /// API核心定义
    enum EndPoint: String {
        static let apiHostURL = URL(string: "https://api.tinify.com")
        case shrink
        var url: URL? {
            get {
                return EndPoint.apiHostURL?.appendingPathComponent(self.rawValue)
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
        
        public struct ResponseModel: Codable {
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
                guard let data = try? EndPoint.jsonEncoder.encode(self) else {
                    return nil
                }
                return String(data: data, encoding: .utf8)
            }
        }
        
        public struct RequestModel: Codable {
            public let source: Source?
            public let resize: Resize?

            public struct Source: Codable {
                public let url: String
            }
            
            /// If the target dimensions are larger than the original dimensions,
            /// the image will not be scaled up. Scaling up is prevented in order to protect the quality of your images.
            public struct Resize: Codable {
                /// The method describes the way your image will be resized.
                public let method: ResizeMethod
                
                /// Resized Image Width
                public let width : Int
                
                /// Resized Image Height
                public let height: Int
                
                /// The method be used esize the original Image
                public enum ResizeMethod: String, Codable {
                    /// Scales the image down proportionally.
                    /// You must provide either a target width or a target height, but not both.
                    /// The scaled image will have exactly the provided width or height.
                    case scale
                    /// Scales the image down proportionally so that it fits within the given dimensions.
                    /// You must provide both a width and a height.
                    /// The scaled image will not exceed either of these dimensions.
                    case fit
                    /// Scales the image proportionally and crops it if necessary so that the result has exactly the given dimensions.
                    /// You must provide both a width and a height. Which parts of the image are cropped away is determined automatically.
                    /// An intelligent algorithm determines the most important areas of your image.
                    case cover
                    /// A more advanced implementation of cover that also detects cut out images with plain backgrounds.
                    /// The image is scaled down to the width and height you provide.
                    /// If an image is detected with a free standing object it will add more background space where necessary or crop the unimportant parts.
                    /// This feature is new and we’d love to hear your feedback!
                    case thumb
                }
                
                public init(_ method: ResizeMethod = .fit, width: Int, height: Int) {
                    self.method = method
                    self.width = width
                    self.height = height
                }
            }
            
            /// 将Model进行JSON编码后再转成二进制数据
            var data: Data? {
                get {
                    return try? EndPoint.jsonEncoder.encode(self)
                }
            }
        }
    }
}



