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
    func testCompressImageWithURLAndDownloadResultAndResizeIt() async throws {
        let imageURL = URL(string: "https://tinify.com/static/images/globe-map.png")
        let (error, result) = try await client.compress(url: imageURL)
        XCTAssertNil(error)
        XCTAssertNotNil(result)
        if let ret = result, let desc = ret.description {
            print(desc)
            let compressedImageData = try await client.download(url: ret.output.url)
            XCTAssertNotNil(compressedImageData)
            let resizeModel = TinyPNGAPI.EndPoint.RequestModel.Resize(.fit, width: ret.output.width / 2 , height: ret.output.height / 2)
            let resizedImageData = try await client.resize(for: ret.output.url, resizeModel: resizeModel)
            XCTAssertNotNil(resizedImageData)
        }
    }
}
