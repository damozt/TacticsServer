//
//  BattleController.swift
//  App
//
//  Created by Kevin Damore on 5/10/19.
//

import Vapor
import PostgreSQL
import FluentPostgreSQL

final class BattleController: BaseController {
    
    func getBattle(_ req: Request) throws -> Future<DataResponse<BattleDetail>> {
        let battleId = try req.parameters.next(Int.self)
        return req.dispatch { request in
            let battle = try Battle.find(battleId, on: request).unwrap(or: Abort(.noContent)).wait()
            let attacker = try User.find(battle.attackerId, on: request).unwrap(or: Abort(.internalServerError)).wait().battleUser(init: battle.attackerInit)
            let defender = try User.find(battle.defenderId, on: request).unwrap(or: Abort(.internalServerError)).wait().battleUser(init: battle.defenderInit)
            let turns = try BattleTurn.query(on: request).filter(\.id, .equal, battle.id).all().wait()
            let new: [BattleTurnDetail] = try turns.map { turn in
                let actions = try BattleAction.query(on: request).filter(\.id, .equal, turn.id).all().wait()
                return turn.with(actions: actions)
            }
            return BattleDetail(id: battle.id, updateTime: battle.updateTime, stageId: battle.stageId, attacker: attacker, defender: defender, turns: new)
        }.map {
            return DataResponse<BattleDetail>(data: $0)
        }
    }
    
    func getUserBattles(_ req: Request) throws -> Future<DataResponse<[BattleDetail]>> {
        let userId = try req.parameters.next(Int.self)
        return req.dispatch { request in
            let battles = try Battle.query(on: request).group(.or) { $0.filter(\.attackerId, .equal, userId).filter(\.defenderId, .equal, userId) }.all().wait()
            return try battles.map { battle in
                let attacker = try User.find(battle.attackerId, on: request).unwrap(or: Abort(.internalServerError)).wait().battleUser(init: battle.attackerInit)
                let defender = try User.find(battle.defenderId, on: request).unwrap(or: Abort(.internalServerError)).wait().battleUser(init: battle.defenderInit)
                return BattleDetail(id: battle.id, updateTime: battle.updateTime, stageId: battle.stageId, attacker: attacker, defender: defender, turns: nil)
            }
        }.map {
            return DataResponse<[BattleDetail]>(data: $0)
        }
    }
    
    func createBattle(_ req: Request, data: CreateBattle) throws -> Future<Battle> {
        
        return req.dispatch { request in
            let user = try self.authenticatedUser(request).wait()
            guard user.id == data.attackerId || user.id == data.defenderId else { throw Abort(.unauthorized) }
            guard try User.find(data.attackerId, on: request).wait() != nil else { throw Abort(.notFound, reason: "User with id: \(data.attackerId) not found") }
            guard try User.find(data.defenderId, on: request).wait() != nil else { throw Abort(.notFound, reason: "User with id: \(data.defenderId) not found") }
            return try Battle.newBattle(from: data).save(on: request).wait()
        }
    }
    
    func updateAttackerInit(_ req: Request, data: TeamInit) throws -> Future<HTTPStatus> {
        
        // make sure battle has not started?
        
        return req.dispatch { request in
            let battleId = try request.parameters.next(Int.self)
            var battle = try Battle.find(battleId, on: request).unwrap(or: Abort(.noContent)).wait()
            guard let userId = try self.authenticatedUser(request).wait().id else { throw Abort(.unauthorized) }
            guard userId == battle.attackerId else { throw Abort(.forbidden) }
            battle.attackerInit = data.data
            battle.updateTime = Date().timeIntervalSince1970
            _ = battle.update(on: request)
            return .ok
        }
    }
    
    func updateDefenderInit(_ req: Request, data: TeamInit) throws -> Future<HTTPStatus> {
        
        // make sure battle has not started?
        
        return req.dispatch { request in
            let battleId = try request.parameters.next(Int.self)
            var battle = try Battle.find(battleId, on: request).unwrap(or: Abort(.noContent)).wait()
            guard let userId = try self.authenticatedUser(request).wait().id else { throw Abort(.unauthorized) }
            guard userId == battle.defenderId else { throw Abort(.forbidden) }
            battle.defenderInit = data.data
            battle.updateTime = Date().timeIntervalSince1970
            _ = battle.update(on: request)
            return .ok
        }
    }
}
