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
    
    func getBattle(_ req: Request) throws -> Future<BattleDetail> {
        let battleId = try req.parameters.next(Int.self)
        return req.dispatch { request in
            let battle = try Battle.find(battleId, on: request).unwrap(or: Abort(.noContent)).wait()
            let attacker = try User.find(battle.attackerId, on: request).unwrap(or: Abort(.internalServerError)).wait()
            let defender = try User.find(battle.defenderId, on: request).unwrap(or: Abort(.internalServerError)).wait()
            let turns = try BattleTurn.query(on: request).filter(\.id, .equal, battle.id).all().wait()
            let new: [BattleTurnDetail] = try turns.map { turn in
                let actions = try BattleAction.query(on: request).filter(\.id, .equal, turn.id).all().wait()
                return turn.with(actions: actions)
            }
            return BattleDetail(id: battle.id, updateTime: battle.updateTime, stageId: battle.stageId, attacker: attacker.publicUser, defender: defender.publicUser, turns: new)
        }
    }
    
    func getUserBattles(_ req: Request) throws -> Future<[BattleDetail]> {
        let userId = try req.parameters.next(Int.self)
        return req.dispatch { request in
            let battles = try Battle.query(on: request).group(.or) { $0.filter(\.attackerId, .equal, userId).filter(\.defenderId, .equal, userId) }.all().wait()
            return try battles.map { battle in
                let attacker = try User.find(battle.attackerId, on: request).unwrap(or: Abort(.internalServerError)).wait()
                let defender = try User.find(battle.defenderId, on: request).unwrap(or: Abort(.internalServerError)).wait()
                return BattleDetail(id: battle.id, updateTime: battle.updateTime, stageId: battle.stageId, attacker: attacker.publicUser, defender: defender.publicUser, turns: nil)
            }
        }
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
