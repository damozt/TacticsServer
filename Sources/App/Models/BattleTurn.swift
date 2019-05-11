//
//  Turn.swift
//  App
//
//  Created by Kevin Damore on 5/10/19.
//

import Vapor
import FluentPostgreSQL

struct BattleTurn: PostgreSQLModel {
    
    var id: Int?
    let turnNumber: Int
    let heroId: Int
    let battleId: Int
    let userId: Int
    let iniativeSwitch: Bool
    
    static func newTurn(from battle: CreateBattleTurn) -> BattleTurn {
        return BattleTurn(id: nil, turnNumber: 1, heroId: battle.heroId, battleId: battle.battleId, userId: battle.userId, iniativeSwitch: battle.initiativeSwitch)
    }
    
    var actions: Children<BattleTurn, BattleAction> {
        return children(\.turnId)
    }
}

extension BattleTurn: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: conn) { (builder) in
            try addProperties(to: builder)
            builder.reference(from: \.battleId, to: \Battle.id, onDelete: ._cascade)
        }
    }
}

extension BattleTurn: Content {}
extension BattleTurn: Parameter {}

struct CreateBattleTurn: Content {
    let battleId: Int
    let heroId: Int
    let userId: Int
    let initiativeSwitch: Bool
}
