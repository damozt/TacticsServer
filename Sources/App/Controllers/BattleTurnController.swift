//
//  BattleTurnController.swift
//  App
//
//  Created by Kevin Damore on 5/11/19.
//

import Vapor
import FluentPostgreSQL

final class BattleTurnController {
    
    func getTurnsForBattle(_ req: Request) throws -> Future<[BattleTurn]> {
        let battleId = try req.parameters.next(Int.self)
        return BattleTurn.query(on: req).filter(\.battleId, .equal, battleId).all()
    }
    
    func createTurn(_ req: Request, data: CreateBattleTurn) throws -> Future<BattleTurn> {
        guard let _ = try req.authenticate() else { throw Abort(.unauthorized) }
        
        return req.dispatch { request in
            var battle = try Battle.find(data.battleId, on: request).unwrap(or: Abort(.noContent)).wait()
            battle.updateTime = Date().timeIntervalSince1970
            _ = battle.update(on: request)
            let newTurn = BattleTurn.new(from: data)
            _ = newTurn.save(on: request)
            return newTurn
        }
    }
}
