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
    let battleId: Int
    let actionId: Int
    let actionInfo: String
    let actionIndex: Int
    let actionType: Int
    
    var detail: BattleActionDetail {
        return BattleActionDetail(actionId: actionId, actionInfo: actionInfo, actionIndex: actionIndex, actionType: actionType)
    }
    
    static func new(from action: CreateBattleAction) -> BattleAction {
        return BattleAction(id: nil, turnId: action.turnId, battleId: action.battleId, actionId: action.actionId, actionInfo: action.actionInfo, actionIndex: action.actionIndex, actionType: action.actionType)
    }
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

struct BattleActionDetail: Content {
    let actionId: Int
    let actionInfo: String
    let actionIndex: Int
    let actionType: Int
}

struct CreateBattleAction: Content {
    
    let battleId: Int
    let turnId: Int
    let actionId: Int
    let actionInfo: String
    let actionIndex: Int
    let actionType: Int
}
