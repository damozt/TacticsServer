//
//  BattleInitController.swift
//  App
//
//  Created by Kevin Damore on 5/26/19.
//

import Vapor
import PostgreSQL
import FluentPostgreSQL

final class BattleInitController: BaseController {
    
    override var rootPathString: String {
        return "battleInit"
    }
    
    func createBattleInit(_ req: Request, data: CreateBattleInit) throws -> Future<DataResponse<BattleInit>> {
        
        return req.dispatch { request in
            let user = try self.authenticatedUser(request).wait()
            guard let userId = user.id else { throw Abort(.internalServerError, reason: "userId not found") }
            guard try Battle.find(data.battleId, on: request).wait() != nil else { throw Abort(.badRequest, reason: "No battle with id: \(data.battleId)") }
            guard try BattleTurn.query(on: request).filter(\.battleId, .equal, data.battleId).all().wait().count == 0 else { throw Abort(.badRequest, reason: "Turns already exist for this battle. Cannot init") }
            let existingBattleInit = try BattleInit.query(on: request).filter(\.battleId, .equal, data.battleId).group(.and) { $0.filter(\.userId, .equal, userId) }.first().wait()
            let battleInit = try BattleInit(with: existingBattleInit?.id, userId: userId, data: data).save(on: request).wait()
            return DataResponse<BattleInit>(data: battleInit)
        }
    }
}
