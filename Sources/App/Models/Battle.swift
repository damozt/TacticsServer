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
    let stageId: String
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
    let heroInits: [BattleInitDetail]
}

struct HeroInit: Content {
    let heroId: Int
    let name: String
    let type: Int
    let actionIds: String
    let tileId: Int
    let direction: Int
}

struct HeroInitDetail: Content {
    let heroId: Int
    let name: String
    let type: Int
    let actionIds: [Int]
    let tileId: Int
    let direction: Int
    
    init?(heroInit: HeroInit) {
        heroId = heroInit.heroId
        name = heroInit.name
        type = heroInit.type
        actionIds = (try? JSONDecoder().decode([Int].self, from: heroInit.actionIds.data(using: .utf8) ?? "")) ?? []
        tileId = heroInit.tileId
        direction = heroInit.direction
    }
}

struct TeamInit: Content {
    let data: String
}

//attacker: [{"heroId":1,"name":"Test","type":0,"actionIds":"[1,100,1000]","tileId":52,"direction":0}]
//defender: [{"heroId":2,"name":"Ramza","type":0,"actionIds":"[1,100,1000]","tileId":50,"direction":0}]
