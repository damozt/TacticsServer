//
//  BattleActionController.swift
//  App
//
//  Created by Kevin Damore on 5/11/19.
//

import Vapor
import FluentPostgreSQL

final class BattleActionController {
    
    func getActionsForBattle(_ req: Request) throws -> Future<[BattleAction]> {
        let battleId = try req.parameters.next(Int.self)
        return BattleAction.query(on: req).filter(\.battleId, .equal, battleId).all()
    }
    
    func createAction(_ req: Request, data: CreateBattleAction) throws -> Future<BattleAction> {
        
        return req.dispatch { request in
            var battle = try Battle.find(data.battleId, on: request).unwrap(or: Abort(.noContent)).wait()
            guard try BattleTurn.find(data.turnId, on: request).wait() != nil else { throw Abort(.noContent) }
            battle.updateTime = Date().timeIntervalSince1970
            _ = battle.update(on: request)
            let newAction = BattleAction.new(from: data)
            _ = newAction.save(on: request)
            return newAction
        }
    }
}
