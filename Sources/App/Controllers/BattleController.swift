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
//        guard let _ = try req.authenticate() else { throw Abort(.unauthorized) }
        
        let battleId = try req.parameters.next(Int.self)
        return req.dispatch { request in
            let battle = try Battle.find(battleId, on: request).unwrap(or: Abort(.badRequest, reason: "Battle with id: \(battleId) doesn't exist")).wait()
            
            let heroInits = try BattleInit.query(on: req).filter(\.battleId, .equal, battleId).all().wait()
            let attackerHeroInits = heroInits.filter { $0.userId == battle.attackerId }.compactMap { BattleInitDetail(battleInit: $0) }
            let defenderHeroInits = heroInits.filter { $0.userId == battle.defenderId }.compactMap { BattleInitDetail(battleInit: $0) }
            
            let attacker = try User.find(battle.attackerId, on: request).unwrap(or: Abort(.internalServerError, reason: "No user with id: \(battle.attackerId)")).map { BattleUser(id: $0.id, name: $0.name, heroInits: attackerHeroInits) }.wait()
            let defender = try User.find(battle.defenderId, on: request).unwrap(or: Abort(.internalServerError, reason: "No user with id: \(battle.defenderId)")).map { BattleUser(id: $0.id, name: $0.name, heroInits: defenderHeroInits) }.wait()
            
            let turns = try BattleTurn.query(on: request).filter(\.battleId, .equal, battleId).all().wait()
//            let actions = try BattleAction.query(on: request).filter(\.battleId, .equal, battleId).all().wait()
            
            let turnsDetail: [BattleTurnDetail] = try turns.sorted(by: { $0.turnNumber < $1.turnNumber } ).compactMap { turn in
                guard let turnId = turn.id else { return nil }
                let actions = try BattleAction.query(on: request).filter(\.turnId, .equal, turnId).all().wait()
                return turn.with(actions: actions)
            }
            
            let battleDetail = BattleDetail(id: battle.id, updateTime: battle.updateTime, stageId: battle.stageId, attacker: attacker, defender: defender, turns: turnsDetail)
            return DataResponse<BattleDetail>(data: battleDetail)
        }
    }
    
    func getUserBattles(_ req: Request) throws -> Future<DataResponse<[BattleDetail]>> {
        
        return req.dispatch { request in
            guard let userId = try self.authenticatedUser(request).wait().id else { throw Abort(.unauthorized) }
            let battles = try Battle.query(on: request).group(.or) { $0.filter(\.attackerId, .equal, userId).filter(\.defenderId, .equal, userId) }.all().wait()
            return try battles.compactMap { battle in
                guard let battleId = battle.id else { return nil }
                
                let heroInits = try BattleInit.query(on: req).filter(\.battleId, .equal, battleId).all().wait()
                let attackerHeroInits = heroInits.filter { $0.userId == battle.attackerId }.compactMap { BattleInitDetail(battleInit: $0) }
                let defenderHeroInits = heroInits.filter { $0.userId == battle.defenderId }.compactMap { BattleInitDetail(battleInit: $0) }
                
                let attacker = try User.find(battle.attackerId, on: request).unwrap(or: Abort(.internalServerError)).map { BattleUser(id: $0.id, name: $0.name, heroInits: attackerHeroInits) }.wait()
                let defender = try User.find(battle.defenderId, on: request).unwrap(or: Abort(.internalServerError)).map { BattleUser(id: $0.id, name: $0.name, heroInits: defenderHeroInits) }.wait()
                
                let turns = try BattleTurn.query(on: request).filter(\.battleId, .equal, battleId).all().wait()
                
                let turnsDetail: [BattleTurnDetail] = try turns.sorted(by: { $0.turnNumber < $1.turnNumber } ).compactMap { turn in
                    guard let turnId = turn.id else { return nil }
                    let actions = try BattleAction.query(on: request).filter(\.turnId, .equal, turnId).all().wait()
                    return turn.with(actions: actions)
                }
                
                return BattleDetail(id: battle.id, updateTime: battle.updateTime, stageId: battle.stageId, attacker: attacker, defender: defender, turns: turnsDetail)
                
            }.sorted { $0.updateTime > $1.updateTime }
        }.map {
            return DataResponse<[BattleDetail]>(data: $0)
        }
    }
    
    func createBattle(_ req: Request, data: CreateBattle) throws -> Future<DataResponse<Battle>> {
        
        return req.dispatch { request in
            let user = try self.authenticatedUser(request).wait()
            guard user.id == data.attackerId || user.id == data.defenderId else { throw Abort(.unauthorized) }
            guard try User.find(data.attackerId, on: request).wait() != nil else { throw Abort(.badRequest, reason: "User with id: \(data.attackerId) doesn't exist") }
            guard try User.find(data.defenderId, on: request).wait() != nil else { throw Abort(.badRequest, reason: "User with id: \(data.defenderId) doesn't exist") }
            let newBattle = try Battle.newBattle(from: data).save(on: request).wait()
            return DataResponse<Battle>(data: newBattle)
        }
    }
}
