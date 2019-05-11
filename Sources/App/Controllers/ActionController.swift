//
//  ActionController.swift
//  App
//
//  Created by Kevin Damore on 5/11/19.
//

import Vapor
import FluentPostgreSQL

final class ActionController {
    
    func createAction(_ req: Request, data: CreateBattleAction) throws -> Future<BattleAction> {
        guard let _ = try req.authenticate() else { throw Abort(.unauthorized) }
        return BattleAction.newAction(from: data).save(on: req)
    }
}
