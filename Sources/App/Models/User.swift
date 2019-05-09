//
//  User.swift
//  App
//
//  Created by Kevin Damore on 5/7/19.
//

import Foundation
import Vapor

struct User: Content {
    
    let id: String
    let name: String
    let rating: Int
}
