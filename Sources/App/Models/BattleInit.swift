//
//  BattleInit.swift
//  App
//
//  Created by Kevin Damore on 5/26/19.
//

import Vapor
import FluentPostgreSQL

struct BattleInit: PostgreSQLModel {
    var id: Int?
    let battleId: Int
    let userId: Int
    let heroId: Int
    let heroName: String
    let heroType: Int
    let action0Id: Int?
    let action1Id: Int?
    let action2Id: Int?
    let action3Id: Int?
    let direction: Int
    let tileId: Int
    
    init(id: Int?, battleId: Int, userId: Int, heroId: Int, heroName: String, heroType: Int, action0Id: Int?, action1Id: Int?, action2Id: Int?, action3Id: Int?, direction: Int, tileId: Int) {
        self.id = id
        self.battleId = battleId
        self.userId = userId
        self.heroId = heroId
        self.heroName = heroName
        self.heroType = heroType
        self.action0Id = action0Id
        self.action1Id = action1Id
        self.action2Id = action2Id
        self.action3Id = action3Id
        self.direction = direction
        self.tileId = tileId
    }
    
    init(with id: Int?, userId: Int, data: CreateBattleInit) {
        self.init(id: id, battleId: data.battleId, userId: userId, heroId: data.heroId, heroName: data.heroName, heroType: data.heroType, action0Id: data.action0Id, action1Id: data.action1Id, action2Id: data.action2Id, action3Id: data.action3Id, direction: data.direction, tileId: data.tileId)
    }
    
//    static func battleInit(with id: Int?, userId: Int, data: CreateBattleInit) -> BattleInit {
//        return BattleInit(
//            id: id,
//            battleId: data.battleId,
//            userId: userId,
//            heroId: data.heroId,
//            heroName: data.heroName,
//            heroType: data.heroType,
//            action0Id: data.action0Id,
//            action1Id: data.action1Id,
//            action2Id: data.action2Id,
//            action3Id: data.action3Id,
//            direction: data.direction,
//            tileId: data.tileId
//        )
//    }
}

extension BattleInit: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: conn) { (builder) in
            try addProperties(to: builder)
            builder.reference(from: \.battleId, to: \Battle.id, onDelete: ._cascade)
        }
    }
}
extension BattleInit: Content {}
extension BattleInit: Parameter {}

struct CreateBattleInit: Content {
    let battleId: Int
    let heroId: Int
    let heroName: String
    let heroType: Int
    let action0Id: Int?
    let action1Id: Int?
    let action2Id: Int?
    let action3Id: Int?
    let direction: Int
    let tileId: Int
}

struct BattleInitDetail: Content {
    let heroId: Int
    let heroName: String
    let heroType: Int
    let action0Id: Int?
    let action1Id: Int?
    let action2Id: Int?
    let action3Id: Int?
    let direction: Int
    let tileId: Int
    
    init?(battleInit: BattleInit) {
        heroId = battleInit.heroId
        heroName = battleInit.heroName
        heroType = battleInit.heroType
        action0Id = battleInit.action0Id
        action1Id = battleInit.action1Id
        action2Id = battleInit.action2Id
        action3Id = battleInit.action3Id
        direction = battleInit.direction
        tileId = battleInit.tileId
    }
}
