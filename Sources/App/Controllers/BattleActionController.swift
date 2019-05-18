//
//  BattleActionController.swift
//  App
//
//  Created by Kevin Damore on 5/11/19.
//

import Vapor
import FluentPostgreSQL

final class BattleActionController: BaseController {
    
    func getActionsForBattle(_ req: Request) throws -> Future<[BattleAction]> { //TODO: Update to DataResponse
        let battleId = try req.parameters.next(Int.self)
        return BattleAction.query(on: req).filter(\.battleId, .equal, battleId).all()
    }
    
    func createAction(_ req: Request, data: CreateBattleAction) throws -> Future<DataResponse<BattleAction>> {
        guard let _ = try authenticatedFirebaseUser(req) else { throw Abort(.unauthorized) }
        
        return req.dispatch { request in
            var battle = try Battle.find(data.battleId, on: request).unwrap(or: Abort(.badRequest, reason: "Battle with id: \(data.battleId) doesn't exist")).wait()
            guard try BattleTurn.find(data.turnId, on: request).wait() != nil else { throw Abort(.badRequest, reason: "Turn with id: \(data.turnId) doesn't exist") }
            battle.updateTime = Date().timeIntervalSince1970
            _ = battle.update(on: request)
            let newAction = BattleAction.new(from: data)
            _ = newAction.save(on: request)
            
            if newAction.actionType == 3 {
                print("send notification telling the other user it is their turn!")
            }
            
            return DataResponse<BattleAction>(data: newAction)
        }
    }
}
