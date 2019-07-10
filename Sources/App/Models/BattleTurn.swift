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
    let initiativeSwitch: Bool
    
    func with(actions: [BattleAction]) -> BattleTurnDetail {
        return BattleTurnDetail(id: id, turnNumber: turnNumber, heroId: heroId, userId: userId, initiativeSwitch: initiativeSwitch, actions: actions.map { $0.detail })
    }
    
    static func new(from turn: CreateBattleTurn, userId: Int) -> BattleTurn {
        return BattleTurn(id: nil, turnNumber: turn.turnNumber, heroId: turn.heroId, battleId: turn.battleId, userId: userId, initiativeSwitch: turn.initiativeSwitch)
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

struct BattleTurnDetail: Content {
    let id: Int?
    let turnNumber: Int
    let heroId: Int
    let userId: Int
    let initiativeSwitch: Bool
    let actions: [BattleActionDetail]
}

struct CreateBattleTurn: Content {
    
    let turnNumber: Int
    let heroId: Int
    let battleId: Int
    let initiativeSwitch: Bool
}
