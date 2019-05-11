//
//  TurnController.swift
//  App
//
//  Created by Kevin Damore on 5/11/19.
//

import Vapor
import FluentPostgreSQL

final class TurnController {
    
    func getTurn(_ req: Request) throws -> Future<BattleTurn> {
        let turnId = try req.parameters.next(Int.self)
        let turns = BattleTurn.query(on: req).filter(\.id, .equal, turnId).all()
        return turns.map { turns in
            guard turns.count > 0 else { throw Abort(.noContent, reason: "No turns found.") }
            guard turns.count == 1 else { throw Abort(.internalServerError) }
            return turns[0]
        }
    }
    
    func getTurnsForBattle(_ req: Request) throws -> Future<[BattleTurn]> {
        let battleId = try req.parameters.next(Int.self)
        return BattleTurn.query(on: req).filter(\.battleId, .equal, battleId).all()
    }
    
    func createTurn(_ req: Request, data: CreateBattleTurn) throws -> Future<BattleTurn> {
        guard let _ = try req.authenticate() else { throw Abort(.unauthorized) }
        return BattleTurn.newTurn(from: data).save(on: req)
    }
}
