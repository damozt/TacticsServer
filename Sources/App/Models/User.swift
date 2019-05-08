//
//  User.swift
//  App
//
//  Created by Kevin Damore on 5/7/19.
//

import Foundation
import Vapor

struct User: Content {
    
    var id: String
    var name: String
    var rating: Int
}
