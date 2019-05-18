//
//  DataResponse.swift
//  App
//
//  Created by Kevin Damore on 5/17/19.
//

import Foundation
import Vapor

struct DataResponse<T:Content>: Content {
    let data: T
}
