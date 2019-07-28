//
//  BattleActionController.swift
//  App
//
//  Created by Kevin Damore on 5/11/19.
//

import Vapor
import FluentPostgreSQL

final class BattleActionController: BaseController {
    
    override var rootPathString: String {
        return "action"
    }
    
    func createAction(_ req: Request, data: CreateBattleAction) throws -> Future<DataResponse<BattleAction>> {
        return req.dispatch { request in
            guard let userId = try self.authenticatedUser(request).wait().id else { throw Abort(.unauthorized) }
            
            let battle = try Battle.find(data.battleId, on: request).unwrap(or: Abort(.badRequest, reason: "Battle with id: \(data.battleId) doesn't exist")).wait()
            
            let newAction = BattleAction.new(from: data)
            _ = newAction.save(on: request)
            
            let opponentId = userId == battle.attackerId ? battle.defenderId : battle.attackerId
            let user = try User.find(opponentId, on: request).unwrap(or: Abort(.internalServerError)).wait()
            
            if newAction.actionType == 2 {
                FCM(
                    to: user.fcmId,
                    title: nil,
                    body: "It's your turn!",
                    battleId: data.battleId
                    ).send()
            }
            
            return DataResponse<BattleAction>(data: newAction)
        }
    }
}
