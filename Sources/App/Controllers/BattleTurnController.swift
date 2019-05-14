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
        return BattleTurn.new(from: data).save(on: req)
    }
}
