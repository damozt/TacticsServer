//
//  Hero.swift
//  App
//
//  Created by Kevin Damore on 5/10/19.
//

import Vapor
import FluentPostgreSQL

struct Hero: PostgreSQLModel {
    
    var id: Int?
    let userId: Int
    let name: String
    let type: Int
    let actionIds: String
}

extension Hero: Migration { }
extension Hero: Content { }
extension Hero: Parameter { }
