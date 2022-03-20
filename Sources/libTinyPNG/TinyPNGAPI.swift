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
    
    public static let testClient = TinyPNGAPI(apiKey: "MWmX23aKKpW6wsJjVC3gW1YUhh6CDOID")
    public static let supportFormats = ["png", "jpg", "jpeg", "webp"]
    
    /// 存入API Key
    let apiKey: String
    
    /// 实始化必须传入API Key
    /// 访问地址： https://tinypng.com/developers
    /// 注册用户名和邮箱即可获取
    ///
    public init(apiKey key: String) {
        apiKey = key
    }
    
    @discardableResult
    /// 压缩本地图片文件，压缩后覆盖原图
    /// - Parameter fileURL: 本地图片文件URL
    /// - Returns: 压缩覆盖是否成功
    public func compressImage(for srcFileURL: URL, dstFileURL: URL) async -> (Bool, TinyPNGAPIResponseModel?)  {
        guard srcFileURL.isFileURL else {
            return (false, nil)
        }
        guard TinyPNGAPI.supportFormats.contains(srcFileURL.pathExtension.lowercased()) else {
            return (false, nil)
        }
        guard let imageData = try? Data(contentsOf: srcFileURL), let (_, result) = try? await compress(imageData: imageData), let resultUrl = result?.output.url else {
            return (false, nil)
        }
        guard let resultImageData = try? await download(url: resultUrl) else {
            return (false, nil)
        }
        do {
            if !FileManager.default.fileExists(atPath: dstFileURL.deletingLastPathComponent().path) {
                try FileManager.default.createDirectory(at: dstFileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            }
            return (FileManager.default.createFile(atPath: dstFileURL.path, contents: resultImageData), result)
        }
        catch {
            return (false, nil)
        }
    }
}



