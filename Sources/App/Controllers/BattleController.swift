//
//  BattleController.swift
//  App
//
//  Created by Kevin Damore on 5/10/19.
//

import Vapor
import PostgreSQL
import FluentPostgreSQL

final class BattleController {
    
    func getBattle(_ req: Request) throws -> Future<Battle> {
        let battleId = try req.parameters.next(Int.self)
        let battles = Battle.query(on: req).filter(\.id, .equal, battleId).all()
        
        return battles.map { battles in
            guard battles.count > 0 else { throw Abort(.noContent, reason: "No battles found.") }
            guard battles.count == 1 else { throw Abort(.internalServerError) }
            let battle = battles[0]
            return battle
        }
    }
    
    func getAllBattles(_ req: Request) throws -> Future<[Battle]> {
        return Battle.query(on: req).all()
    }
    
    func createBattle(_ req: Request, data: CreateBattle) throws -> Future<Battle> {
        guard let _ = try req.authenticate() else { throw Abort(.unauthorized) }
        return Battle.newBattle(from: data).save(on: req)
    }
    
    func updateAttackerInit(_ req: Request, data: TeamInit) throws -> Future<HTTPStatus> {
        let battleId = try req.parameters.next(Int.self)
        return Battle.query(on: req).filter(\.id, .equal, battleId).update(\.attackerInit, to: data.data).run().transform(to: .ok)
    }
    
    func updateDefenderInit(_ req: Request, data: TeamInit) throws -> Future<HTTPStatus> {
        let battleId = try req.parameters.next(Int.self)
        return Battle.query(on: req).filter(\.id, .equal, battleId).update(\.defenderInit, to: data.data).run().transform(to: .ok)
    }
}
