//
//  Battle.swift
//  App
//
//  Created by Kevin Damore on 5/10/19.
//

import Vapor
import FluentPostgreSQL

//TODO: BattleDetail

final class Battle: PostgreSQLModel {
    
    var id: Int?
    var updateTime: TimeInterval
    let stageId: String
    let attackerId: Int
    let defenderId: Int
    var attackerInit: String
    var defenderInit: String
    
    init(id: Int?, updateTime: TimeInterval, stageId: String, attackerId: Int, defenderId: Int, attackerInit: String, defenderInit: String) {
        self.id = id
        self.updateTime = updateTime
        self.stageId = stageId
        self.attackerId = attackerId
        self.defenderId = defenderId
        self.attackerInit = attackerInit
        self.defenderInit = defenderInit
    }
    
    static func newBattle(from battle: CreateBattle) -> Battle {
        return Battle(id: nil, updateTime: Date().timeIntervalSince1970, stageId: battle.stageId, attackerId: battle.attackerId, defenderId: battle.defenderId, attackerInit: "{}", defenderInit: "{}")
    }
}

extension Battle: Migration {}
extension Battle: Content {}
extension Battle: Parameter {}

struct CreateBattle: Content {
    let stageId: String
    let attackerId: Int
    let defenderId: Int
}

struct BattleDetail: Content {
    
    var id: Int?
    var updateTime: TimeInterval
    let stageId: String
    let attacker: BattleUser?
    let defender: BattleUser?
    let turns: [BattleTurnDetail]?
}

struct BattleUser: Content {
    
    let id: Int?
    let name: String
    let `init`: String
}

struct TeamInit: Content {
    let data: String
}
