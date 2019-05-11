//
//  BattleController.swift
//  App
//
//  Created by Kevin Damore on 5/10/19.
//

import Vapor
import JWT
import PostgreSQL
import FluentPostgreSQL

final class BattleController {
    
    func createBattle(_ req: Request, data: CreateBattle) throws -> Future<Battle> {
        guard let _ = try req.authenticate() else { throw Abort(.unauthorized) }
        return Battle.newBattle(from: data).save(on: req)
    }
}
