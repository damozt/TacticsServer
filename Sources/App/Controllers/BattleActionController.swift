//
//  BattleActionController.swift
//  App
//
//  Created by Kevin Damore on 5/11/19.
//

import Vapor
import FluentPostgreSQL

final class BattleActionController: BaseController {
    
    func getActionsForBattle(_ req: Request) throws -> Future<DataResponse<[BattleAction]>> {
        return req.dispatch { request in
            let battleId = try request.parameters.next(Int.self)
            let actions = try BattleAction.query(on: request).filter(\.battleId, .equal, battleId).all().wait()
            return DataResponse<[BattleAction]>(data: actions)
        }
    }
    
    func createAction(_ req: Request, data: CreateBattleAction) throws -> Future<DataResponse<BattleAction>> {
        guard let _ = try authenticatedFirebaseUser(req) else { throw Abort(.unauthorized) }
        
        return Battle.find(data.battleId, on: req).unwrap(or: Abort(.badRequest, reason: "Battle with id: \(data.battleId) doesn't exist")).map { battle in
//            battle.updateTime = Date().timeIntervalSince1970
            _ = battle.update(on: req)
            let newAction = BattleAction.new(from: data)
            _ = newAction.save(on: req)
            
            if newAction.actionType == 3 {
                print("send notification telling the other user it is their turn!")
            }
            
            return DataResponse<BattleAction>(data: newAction)
        }
    }
}
