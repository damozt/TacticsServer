//
//  Request+Dispatch.swift
//  App
//
//  Created by Kevin Damore on 5/10/19.
//

import Vapor

extension Request {
    
    func dispatch<T>(handler: @escaping (Request) throws -> T) -> Future<T> {
        let promise = eventLoop.newPromise(T.self)
        
        DispatchQueue.global().async {
            do {
                let result = try handler(self)
                promise.succeed(result: result)
            } catch {
                promise.fail(error: error)
            }
        }
        
        return promise.futureResult
    }
}
