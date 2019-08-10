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
    var updateTime: TimeInterval
    let stageId: Int
    let attackerId: Int
    let defenderId: Int
    
    static func newBattle(from battle: CreateBattle) -> Battle {
        return Battle(
            id: nil,
            updateTime: Date().timeIntervalSince1970,
            stageId: battle.stageId,
            attackerId: battle.attackerId,
            defenderId: battle.defenderId
        )
    }
}

extension Battle: Migration {}
extension Battle: Content {}
extension Battle: Parameter {}

struct CreateBattle: Content {
    let stageId: Int
    let attackerId: Int
    let defenderId: Int
}

struct BattleDetail: Content {
    var id: Int?
    var updateTime: TimeInterval
    let stageId: Int
    let attacker: BattleUser?
    let defender: BattleUser?
    let turns: [BattleTurnDetail]?
}

struct BattleUser: Content {
    let id: Int?
    let name: String
    let color1: String
    let color2: String
    let heroInits: [BattleInitDetail]
}

struct HeroInit: Content {
    let heroId: Int
    let name: String
    let type: Int
    let actionIds: String //TODO: update to have the 4/8 actionIds
    let tileId: Int
    let direction: Int
}
