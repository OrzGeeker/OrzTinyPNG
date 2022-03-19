//
//  LibTinyPNGTests.swift
//  
//
//  Created by joker on 2022/3/19.
//

import XCTest
@testable import libTinyPNG

class LibTinyPNGTests: XCTestCase {
    let client = TinyPNGAPI(apiKey: "MWmX23aKKpW6wsJjVC3gW1YUhh6CDOID")
    let testImageURL = URL(string: "https://tinify.com/static/images/globe-map.png")
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
}
