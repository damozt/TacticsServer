//
//  Battle.swift
//  App
//
//  Created by Kevin Damore on 5/10/19.
//

import Vapor
import FluentPostgreSQL

//TODO: BattleDetail

struct Battle: PostgreSQLModel {
    
    var id: Int?
    var updateTime: TimeInterval
    let stageId: String
    let attackerId: Int
    let defenderId: Int
    let attackerInit: String
    let defenderInit: String
    
    static func newBattle(from battle: CreateBattle) -> Battle {
        return Battle(id: nil, updateTime: Date().timeIntervalSince1970, stageId: battle.stageId, attackerId: battle.attackerId, defenderId: battle.defenderId, attackerInit: "{}", defenderInit: "{}")
    }
    
//    static func battleDetail(from battle: Battle) -> BattleDetail {
//        let attackerTeam = BattleDetailTeam(teamId: battle.attackerId, teamName: "Attacker", teamInit: battle.attackerInit)
//        let defenderTeam = BattleDetailTeam(teamId: battle.defenderId, teamName: "Defender", teamInit: battle.defenderInit)
//        return BattleDetail(id: battle.id, updateTime: battle.updateTime, stageId: battle.stageId, attackerTeam: attackerTeam, defenderTeam: defenderTeam, turns: [])
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

struct TeamInit: Content {
    let data: String
}
