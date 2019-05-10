//
//  Battle.swift
//  App
//
//  Created by Kevin Damore on 5/10/19.
//

import Vapor
import FluentPostgreSQL

struct Battle: PostgreSQLModel {
    
    var id: Int?
    let updateTime: TimeInterval
    let stageId: Int
    let attackerId: Int
    let defenderId: Int
    let attackerInit: String
    let defenderInit: String
}

extension Battle: Migration { }
extension Battle: Content { }
extension Battle: Parameter { }
