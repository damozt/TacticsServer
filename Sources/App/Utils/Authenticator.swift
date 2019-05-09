//
//  Authenticator.swift
//  App
//
//  Created by Kevin Damore on 5/8/19.
//

import Vapor

extension URL {
    func asyncDownload(completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: self, completionHandler: completion).resume()
    }
}
