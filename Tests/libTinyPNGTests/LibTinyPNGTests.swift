//
//  LibTinyPNGTests.swift
//  
//
//  Created by joker on 2022/3/19.
//

import XCTest
@testable import libTinyPNG
import Foundation

class LibTinyPNGTests: XCTestCase {
    let client = TinyPNGAPI(apiKey: "MWmX23aKKpW6wsJjVC3gW1YUhh6CDOID")
    let testImageURL = URL(string: "https://tinify.com/static/images/globe-map.png")
    let testBundle = Bundle(for: LibTinyPNGTests.self)
    lazy var testTempDirFileURL: URL = {
        return URL(string: "file://\(NSHomeDirectory())")!.appendingPathComponent("Desktop") .appendingPathComponent(testBundle.bundleIdentifier!)
    }()
    func testCompressImageWithURLAndDownloadResultAndResizeIt() async throws {
        let (error, result) = try await client.compress(url: testImageURL)
        XCTAssertNil(error)
        XCTAssertNotNil(result)
        if let ret = result {
            let compressedImageData = try await client.download(url: ret.output.url)
            XCTAssertNotNil(compressedImageData)
            let resizeModel = TinyPNGAPIRequestModel.Resize(.fit, width: ret.output.width / 2 , height: ret.output.height / 2)
            let resizedImageData = try await client.resize(for: ret.output.url, resizeModel: resizeModel)
            XCTAssertNotNil(resizedImageData)
        }
    }
    func testCompressImageWithData() async throws {
        let imageData = try Data(contentsOf: testImageURL!)
        let (error, result) = try await client.compress(imageData: imageData)
        XCTAssertNil(error)
        XCTAssertNotNil(result)
    }
    func testCompressLocalImageFile() async throws {
        // TODO: 获取Bundle中的图片资源文件URL
        if let srcFileURL = URL(string: "file:///Users/joker/Downloads/test.webp") {
            let dstFileURL = testTempDirFileURL.appendingPathComponent(srcFileURL.lastPathComponent)
            let ret = await client.compressImage(for: srcFileURL, dstFileURL: dstFileURL)
            XCTAssertTrue(ret)
        }
    }
    
    override func tearDownWithError() throws {
        // 测试结束后，清理临时文件目录
        if FileManager.default.fileExists(atPath: testTempDirFileURL.path) {
            try FileManager.default.removeItem(at: testTempDirFileURL)
        }
    }
}
