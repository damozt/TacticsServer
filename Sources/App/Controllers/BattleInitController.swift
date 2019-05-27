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
    
    func createBattleInit(_ req: Request, data: CreateBattleInit) throws -> Future<DataResponse<BattleInit>> {
        
        return req.dispatch { request in
            let user = try self.authenticatedUser(request).wait()
            guard let userId = user.id else { throw Abort(.internalServerError) }
            guard try Battle.find(data.battleId, on: request).wait() != nil else { throw Abort(.badRequest) }
            guard try BattleTurn.query(on: request).filter(\.battleId, .equal, data.battleId).all().wait().count == 0 else { throw Abort(.badRequest) }
            let existingBattleInit = try BattleInit.query(on: request).filter(\.battleId, .equal, data.battleId).group(.and) { $0.filter(\.userId, .equal, userId) }.first().wait()
            let battleInit = try BattleInit(id: existingBattleInit?.id, battleId: data.battleId, userId: data.userId, heroId: data.heroId, heroName: data.heroName, heroType: data.heroType, actionIds: data.actionIds, direction: data.direction, tileId: data.tileId).save(on: request).wait()
            return DataResponse<BattleInit>(data: battleInit)
        }
    }
}
