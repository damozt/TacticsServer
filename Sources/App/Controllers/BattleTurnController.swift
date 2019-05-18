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
        guard let _ = try authenticatedFirebaseUser(req) else { throw Abort(.unauthorized) }
        
        throw Abort(.internalServerError)
        
//        return Battle.find(data.battleId, on: req).unwrap(or: Abort(.badRequest, reason: "Battle with id: \(data.battleId) doesn't exist")).map { battle in
//            guard data.userId == battle.attackerId || data.userId == battle.defenderId else { throw Abort(.badRequest, reason: "No user with id: \(data.userId) exists in this battle") }
//            battle.updateTime = Date().timeIntervalSince1970
//            _ = battle.update(on: req)
//            let newTurn = BattleTurn.new(from: data)
//            _ = newTurn.save(on: req)
//            return DataResponse<BattleTurn>(data: newTurn)
//        }
    
//        return req.dispatch { request in
//            let battle = try Battle.find(data.battleId, on: request).unwrap(or: Abort(.badRequest, reason: "Battle with id: \(data.battleId) doesn't exist")).wait()
//            guard data.userId == battle.attackerId || data.userId == battle.defenderId else { throw Abort(.badRequest, reason: "No user with id: \(data.userId) exists in this battle") }
//            // TODO: make sure heroId exists in db
//            battle.updateTime = Date().timeIntervalSince1970
//            _ = battle.update(on: request)
//            let newTurn = BattleTurn.new(from: data)
//            _ = newTurn.save(on: request)
//            return DataResponse<BattleTurn>(data: newTurn)
//        }
    }
}
