//
//  BattleTurnController.swift
//  App
//
//  Created by Kevin Damore on 5/11/19.
//

import Vapor
import FluentPostgreSQL

final class BattleTurnController: BaseController {
    
    override var rootPathString: String {
        return "turn"
    }
    
    func createTurn(_ req: Request, data: CreateBattleTurn) throws -> Future<DataResponse<BattleTurn>> {
        
        return req.dispatch { request in
            guard let userId = try self.authenticatedUser(request).wait().id else { throw Abort(.unauthorized) }
            var battle = try Battle.find(data.battleId, on: request).unwrap(or: Abort(.badRequest, reason: "Battle with id: \(data.battleId) doesn't exist")).wait()
            guard userId == battle.attackerId || userId == battle.defenderId else { throw Abort(.badRequest, reason: "No user with id: \(userId) exists in this battle") }
            
            _ = try Hero.find(data.heroId, on: request).unwrap(or: Abort(.notFound, reason: "No hero with id: \(data.heroId) exists")).wait()
            
            // TODO: make sure heroId exists in db
            battle.updateTime = Date().timeIntervalSince1970
            _ = battle.update(on: request)
            let newTurn = try BattleTurn.new(from: data, userId: userId).save(on: request).wait()
            return DataResponse<BattleTurn>(data: newTurn)
        }
    }
}
