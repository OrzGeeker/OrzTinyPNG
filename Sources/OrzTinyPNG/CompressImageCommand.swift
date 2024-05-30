//
//  File.swift
//
//
//  Created by joker on 2022/3/20.
//

import ConsoleKit
import Foundation
import libTinyPNG

final class CompressImageCommand: AsyncCommand {
    let help: String = "图片压缩工具，支持的图片格式: PNG、JPG、WebP"
    struct Signature: CommandSignature {
        @Argument(name: "input", help: "将要压缩的图片路径")
        var input: String
        @Option(name: "number", help: "执行n次压缩")
        var number: Int?
        @Option(name: "output", short: "o", help: "压缩后存放的图片路径, 如果不设置，默认替换原图片")
        var output: String?
    }
    func run(using context: CommandContext, signature: Signature) async throws {
        let srcFileURL = URL(fileURLWithPath: signature.input)
        guard FileManager.default.fileExists(atPath: srcFileURL.path) else {
            context.console.output("图片不存在".consoleText(.error))
            return
        }
        var srcFileURLs = [URL]()
        if srcFileURL.hasDirectoryPath {
            srcFileURLs = try getAllImageFileURLs(at: srcFileURL)
        }
        else {
            srcFileURLs.append(srcFileURL)
        }
        let totolCount = srcFileURLs.count
        var currentCount = 0
        let progressBarQueue = DispatchQueue.global()
        for srcFileURL in srcFileURLs {
            var dstFileURL = srcFileURL
            if let outputFilePath = signature.output {
                dstFileURL = URL(fileURLWithPath: outputFilePath)
            }
            if dstFileURL.hasDirectoryPath {
                dstFileURL = dstFileURL.appendingPathComponent(srcFileURL.lastPathComponent)
            }
            let srcFileSize = try FileManager.default.attributesOfItem(atPath: srcFileURL.path)[.size] as? Int
            currentCount += 1
            let title = "[\(currentCount)/\(totolCount)] - \(srcFileURL.lastPathComponent)"

            let loadingBar = context.console.loadingBar(title: title, targetQueue: progressBarQueue)
            loadingBar.start()
            let (success, delta) = await execComporess(srcFileURL: srcFileURL, dstFileURL: dstFileURL, number: signature.number)
            guard success, let delta
            else {
                loadingBar.fail()
                return
            }
            var sign: String? = nil
            if delta > 0 {
                sign = "+"
            } else if delta < 0 {
                sign = "-"
            } else {
                sign = ""
            }
            let dstFileSize = try FileManager.default.attributesOfItem(atPath: dstFileURL.path)[.size] as? Int
            if let srcFileSize, let dstFileSize,
               let inputSizeDesc = srcFileSize.fileSizeDesc,
               let outputSizeDesc = dstFileSize.fileSizeDesc,
               let sign = sign, let absDeltaDesc = abs(delta).fileSizeDesc {
                loadingBar.activity.title = title + " (\(inputSizeDesc) -> \(outputSizeDesc))[\(sign)\(absDeltaDesc)]"
            }
            loadingBar.succeed()
        }
    }
}


extension CompressImageCommand {
    func getAllImageFileURLs(at dirFileURL: URL) throws -> [URL] {
        var ret = [URL]()
        try FileManager.default.contentsOfDirectory(atPath: dirFileURL.path).forEach({ filePath in
            let fileURL = dirFileURL.appendingPathComponent(filePath)
            if fileURL.hasDirectoryPath {
                let dirFileURLs = try getAllImageFileURLs(at: fileURL)
                ret.append(contentsOf: dirFileURLs)
            }
            else {
                if TinyPNGAPI.supportFormats.contains(fileURL.pathExtension.lowercased()) {
                    ret.append(fileURL)
                }
            }
        })
        return ret
    }
    func execComporess(srcFileURL: URL, dstFileURL: URL, number: Int?) async -> (success: Bool, delta: Int?) {
        var delta: Int?
        var conditions  = true
        var count = 0
        while conditions {
            let (ret, response) = await TinyPNGAPI.testClient.compressImage(for:srcFileURL, dstFileURL:dstFileURL)
            guard ret, let resp = response else {
                return (false, nil)
            }
            delta = resp.output.size - resp.input.size
            count += 1
            if let number {
                conditions = (number > count)
            } else {
                conditions = (delta != 0)
            }
        }
        return (true, delta)
    }
}
