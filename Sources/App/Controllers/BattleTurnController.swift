//
//  BattleTurnController.swift
//  App
//
//  Created by Kevin Damore on 5/11/19.
//

import Vapor
import FluentPostgreSQL

final class BattleTurnController {
    
    func getTurnsForBattle(_ req: Request) throws -> Future<[BattleTurn]> { //TODO: Update to DataResponse
        let battleId = try req.parameters.next(Int.self)
        return BattleTurn.query(on: req).filter(\.battleId, .equal, battleId).all()
    }
    
    func createTurn(_ req: Request, data: CreateBattleTurn) throws -> Future<DataResponse<BattleTurn>> {
        guard let _ = try req.authenticate() else { throw Abort(.unauthorized) }
        
        return req.dispatch { request in
            var battle = try Battle.find(data.battleId, on: request).unwrap(or: Abort(.badRequest, reason: "Battle with id: \(data.battleId) doesn't exist")).wait()
            guard data.userId == battle.attackerId || data.userId == battle.defenderId else { throw Abort(.badRequest, reason: "No user with id: \(data.userId) exists in this battle") }
            // TODO: make sure heroId exists in db
            battle.updateTime = Date().timeIntervalSince1970
            _ = battle.update(on: request)
            let newTurn = BattleTurn.new(from: data)
            _ = newTurn.save(on: request)
            return DataResponse<BattleTurn>(data: newTurn)
        }
    }
}
