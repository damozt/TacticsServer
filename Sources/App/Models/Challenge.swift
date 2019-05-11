//
//  Challenge.swift
//  App
//
//  Created by Kevin Damore on 5/10/19.
//

import Vapor
import FluentPostgreSQL

struct Challenge: PostgreSQLModel, Migration, Content {
    
    var id: Int?
    let attackerId: Int
    let defenderId: Int
    let attackerStatus: Int
    let defenderStatus: Int
}
