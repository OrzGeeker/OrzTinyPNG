//
//  LibTinyPNGTests.swift
//  
//
//  Created by joker on 2022/3/19.
//

import XCTest
@testable import libTinyPNG
import Foundation
import Foundation.NSBundle

class LibTinyPNGTests: XCTestCase {
    /// [testTarget 中获取Resources](https://developer.apple.com/documentation/swift_packages/bundling_resources_with_a_swift_package)
    let testResourceBundle = Bundle.module
    let client = TinyPNGAPI(apiKey: "MWmX23aKKpW6wsJjVC3gW1YUhh6CDOID")
    let testImageURL = URL(string: "https://tinify.com/static/images/globe-map.png")
    let testBundle = Bundle(for: LibTinyPNGTests.self)
    lazy var testTempDirFileURL: URL? = {
        if let bundleId = testBundle.bundleIdentifier, let desktopDirFileURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first {
            let tempDirURL = desktopDirFileURL.appendingPathComponent(bundleId)
            return tempDirURL;
        }
        return nil
    }()
    func testCompressImageWithURLAndDownloadResultAndResizeIt() async throws {
        let (error, result) = try await client.compress(url: testImageURL)
        XCTAssertNil(error, "网络图片压缩失败")
        XCTAssertNotNil(result)
        if let ret = result {
            let compressedImageData = try await client.download(url: ret.output.url)
            XCTAssertNotNil(compressedImageData, "压缩后的图片下载失败")
            let resizeModel = TinyPNGAPIRequestModel.Resize(.fit, width: ret.output.width / 2 , height: ret.output.height / 2)
            let resizedImageData = try await client.resize(for: ret.output.url, resizeModel: resizeModel)
            XCTAssertNotNil(resizedImageData, "压缩后的图片缩放失败")
        }
    }
    func testCompressImageWithData() async throws {
        let imageData = try Data(contentsOf: testImageURL!)
        let (error, result) = try await client.compress(imageData: imageData)
        XCTAssertNil(error, "本地图片压缩失败")
        XCTAssertNotNil(result)
    }
    func testCompressLocalImageFile() async throws {
        XCTAssertNotNil(testTempDirFileURL, "获测试用的临时目录失败")
        let testImageFileURLs = ["png", "jpg", "JPEG", "webp"]
            .map { testResourceBundle.url(forResource: "test", withExtension: $0) }
            .compactMap { $0 }
        for testImageFileURL in testImageFileURLs {
            XCTAssertNotNil(testImageFileURL, "测试图片路径获取失败")
            if let testTempDirFileURL = testTempDirFileURL {
                let dstFileURL = testTempDirFileURL.appendingPathComponent(testImageFileURL.lastPathComponent)
                let ret = await client.compressImage(for: testImageFileURL, dstFileURL: dstFileURL)
                XCTAssertTrue(ret, "压缩图片失败")
            }
        }
    }
    override func tearDownWithError() throws {
        // 测试结束后，清理临时文件目录
        if let testTempDirFileURL = testTempDirFileURL, FileManager.default.fileExists(atPath: testTempDirFileURL.path) {
            try FileManager.default.removeItem(atPath: testTempDirFileURL.path)
        }
    }
}
