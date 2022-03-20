//
//  File.swift
//  
//
//  Created by joker on 2022/3/20.
//

import Foundation

public struct TinyPNGAPIRequestModel: Codable {
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
            return try? TinyPNGAPIEndPoint.jsonEncoder.encode(self)
        }
    }
}
