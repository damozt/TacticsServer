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
    let stageId: String
    let attackerId: Int
    let defenderId: Int
    let attackerInit: String
    let defenderInit: String
    
    static func newBattle(from battle: CreateBattle) -> Battle {
        return Battle(id: nil, updateTime: Date().timeIntervalSince1970, stageId: battle.stageId, attackerId: battle.attackerId, defenderId: battle.defenderId, attackerInit: "{}", defenderInit: "{}")
    }
    
//    var turns: Children<Battle, BattleTurn> {
//        return children(\.battleId)
////        PostgreSQLDataType.json //TODO: User for creating inits?
//    }
}

extension Battle: Migration {}
extension Battle: Content {}
extension Battle: Parameter {}

struct CreateBattle: Content {
    let stageId: String
    let attackerId: Int
    let defenderId: Int
}
