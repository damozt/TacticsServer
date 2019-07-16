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
//            _ = battle.update(on: req)
            let newAction = BattleAction.new(from: data)
            _ = newAction.save(on: req)
            
            if newAction.actionType == 3 {
                FCM(
                    to: "eCnb9l-4H1M:APA91bExdyCyiF2jaN9MPv0_cDaV67aK8TcZeVGyECIXEgDCYQiNpckX6VXyv9ZIslyYSR3Az9mWYwRyZd2ogqb69auXisjjEe3LDlXWmnJHSvnTQVVVSfsjIXRJLWP7NONEabhr9nRE",
                    title: "For Glory",
                    body: "It's your turn!",
                    battleId: data.battleId
                ).send()
            }
            
            return DataResponse<BattleAction>(data: newAction)
        }
    }
}
