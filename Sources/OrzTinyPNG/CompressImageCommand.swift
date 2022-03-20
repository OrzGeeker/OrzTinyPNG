//
//  File.swift
//  
//
//  Created by joker on 2022/3/20.
//

import ConsoleKit
import Foundation
import libTinyPNG

final class CompressImageCommand: Command {
    var help: String = "图片压缩工具，支持的图片格式: PNG、JPG、WebP"
    struct Signature: CommandSignature {
        @Argument(name: "input", help: "将要压缩的图片路径")
        var input: String
        @Option(name: "output", short: "o", help: "压缩后存放的图片路径, 如果不设置，默认替换原图片")
        var output: String?
    }
    func run(using context: CommandContext, signature: Signature) throws {
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
        do {
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
                currentCount += 1
                let loadingBar = context.console.loadingBar(title: "[\(currentCount)/\(totolCount)] - \(srcFileURL.lastPathComponent)", targetQueue: progressBarQueue)
                loadingBar.start()
                try DispatchGroup().syncExecAndWait {
                    guard await TinyPNGAPI.testClient.compressImage(for:srcFileURL, dstFileURL:dstFileURL) else {
                        loadingBar.fail()
                        return
                    }
                    loadingBar.succeed()
                } errorClosure: { error in
                    loadingBar.fail()
                    context.console.error(error.localizedDescription, newLine: true)
                }
            }
        }
        catch {
            context.console.error(error.localizedDescription, newLine: true)
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
}
