//
//  Int+.swift
//
//
//  Created by joker on 2024/5/30.
//

extension Int {
    static let fileSizeUnits = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB", "BB"]
    var fileSizeDesc: String? {
        var unitIndex = -1
        var ret = Double(self)
        var last = ret
        repeat {
            last = ret
            ret /= 1024.0
            unitIndex += 1
        } while ret > 1.0
        guard unitIndex >= 0, unitIndex < Int.fileSizeUnits.count else {
            return nil
        }
        return String(format: "%.2lf\(Int.fileSizeUnits[unitIndex])", last)
    }
}
