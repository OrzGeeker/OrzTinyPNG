//
//  File.swift
//  
//
//  Created by joker on 2022/3/20.
//

import Foundation

extension TinyPNGAPI {
    
    /// 压缩图片
    /// - Parameter imageData: 原始图片二进制数据
    func compress(imageData: Data) async throws -> (TinyPNGAPIError?, TinyPNGAPIResponseModel?) {
        guard let enpointShrinkURL = TinyPNGAPIEndPoint.shrink.url else {
            throw TinyPNGAPIError.invalidEndpointURL
        }
        let request = try TinyPNGAPIEndPoint.makeRequest(for: enpointShrinkURL, with: self.apiKey, httpMethod: "POST", httpBody: imageData)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            return (.responseFailed, nil)
        }
        let ret = try TinyPNGAPIEndPoint.jsonDecoder.decode(TinyPNGAPIResponseModel.self, from: data)
        return (nil, ret)
    }
    
    /// 压缩图片
    /// - Parameter url: 网络图片URL
    func compress(url: URL?) async throws -> (TinyPNGAPIError?, TinyPNGAPIResponseModel?) {
        guard let imageURL = url else {
            return (.invalidImageURL, nil)
        }
        
        guard let enpointShrinkURL = TinyPNGAPIEndPoint.shrink.url else {
            throw TinyPNGAPIError.invalidEndpointURL
        }
        
        let source = TinyPNGAPIRequestModel.Source(url: imageURL.absoluteString)
        let reqModel = TinyPNGAPIRequestModel(source: source, resize: nil)
        let request = try TinyPNGAPIEndPoint.makeRequest(for: enpointShrinkURL, with: self.apiKey, httpMethod: "POST", httpBody: reqModel.data)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            return (.responseFailed, nil)
        }
        let ret = try TinyPNGAPIEndPoint.jsonDecoder.decode(TinyPNGAPIResponseModel.self, from: data)
        return (nil, ret)
    }
    
    /// 下载压缩后的图片
    /// - Parameter url: 压缩后的图片URL
    /// - Returns: 图片二进制数据
    func download(url: URL) async throws -> Data {
        let request = try TinyPNGAPIEndPoint.makeRequest(for: url, with: apiKey)
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
    func resize(for url: URL, resizeModel: TinyPNGAPIRequestModel.Resize) async throws -> Data {
        let reqModel = TinyPNGAPIRequestModel(source: nil, resize: resizeModel)
        let request = try TinyPNGAPIEndPoint.makeRequest(for: url, with: apiKey, httpMethod: "POST", httpBody: reqModel.data)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw TinyPNGAPIError.resizeImageFailed
        }
        return data
    }
}
