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
    let actionIds: String
    let direction: Int
    let tileId: Int
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
    let userId: Int
    let heroId: Int
    let heroName: String
    let heroType: Int
    let actionIds: String
    let direction: Int
    let tileId: Int
}

struct BattleInitDetail: Content {
    let heroId: Int
    let heroName: String
    let heroType: Int
    let actionIds: [Int]
    let direction: Int
    let tileId: Int
    
    init?(battleInit: BattleInit) {
        heroId = battleInit.heroId
        heroName = battleInit.heroName
        heroType = battleInit.heroType
        actionIds = (try? JSONDecoder().decode([Int].self, from: battleInit.actionIds.data(using: .utf8) ?? "")) ?? []
        direction = battleInit.direction
        tileId = battleInit.tileId
    }
}
