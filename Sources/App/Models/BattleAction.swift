//
//  BattleAction.swift
//  App
//
//  Created by Kevin Damore on 5/10/19.
//

import Vapor
import FluentPostgreSQL

struct BattleAction: PostgreSQLModel {
    
    var id: Int?
    let turnId: Int
    let actionId: String
    let actionInfo: String
    let actionIndex: Int
    let actionType: Int
}

extension BattleAction: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: conn) { (builder) in
            try addProperties(to: builder)
            builder.reference(from: \.turnId, to: \BattleTurn.id, onDelete: ._cascade)
        }
    }
}

extension BattleAction: Content {}
extension BattleAction: Parameter {}
