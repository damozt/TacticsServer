//
//  UserMap.swift
//  App
//
//  Created by Kevin Damore on 5/10/19.
//

import Vapor
import FluentPostgreSQL

struct UserMap: PostgreSQLUUIDModel {
    
    var id: UUID?
    let firebaseId: String
    let userId: Int
}

extension UserMap: Migration { }
extension UserMap: Content { }
extension UserMap: Parameter { }
