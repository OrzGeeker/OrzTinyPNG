//
//  File.swift
//  
//
//  Created by joker on 2022/3/20.
//

import Foundation
import Dispatch

public extension DispatchGroup {
    func syncExecAndWait(
        _ taskClosure: @escaping () async throws -> Void,
        errorClosure: @escaping (Error) -> Void
    ) throws {
        self.enter()
        Task {
            do {
                try await taskClosure()
                self.leave()
            }
            catch let error {
                errorClosure(error)
                self.leave()
            }
        }
        self.wait()
    }
}
