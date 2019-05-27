//
//  BattleTurnController.swift
//  App
//
//  Created by Kevin Damore on 5/11/19.
//

import Vapor
import FluentPostgreSQL

final class BattleTurnController: BaseController {
    
    func getTurnsForBattle(_ req: Request) throws -> Future<DataResponse<[BattleTurn]>> {
        return req.dispatch { request in
            let battleId = try request.parameters.next(Int.self)
            let turns = try BattleTurn.query(on: request).filter(\.battleId, .equal, battleId).all().wait()
            return DataResponse<[BattleTurn]>(data: turns)
        }
    }
    
    func createTurn(_ req: Request, data: CreateBattleTurn) throws -> Future<DataResponse<BattleTurn>> {
        
        return req.dispatch { request in
            guard let userId = try self.authenticatedUser(request).wait().id else { throw Abort(.unauthorized) }
            var battle = try Battle.find(data.battleId, on: request).unwrap(or: Abort(.badRequest, reason: "Battle with id: \(data.battleId) doesn't exist")).wait()
            guard userId == battle.attackerId || userId == battle.defenderId else { throw Abort(.badRequest, reason: "No user with id: \(userId) exists in this battle") }
            // TODO: make sure heroId exists in db
            battle.updateTime = Date().timeIntervalSince1970
            _ = battle.update(on: request)
            let newTurn = BattleTurn.new(from: data, userId: userId)
            _ = newTurn.save(on: request)
            return DataResponse<BattleTurn>(data: newTurn)
        }
    }
}
