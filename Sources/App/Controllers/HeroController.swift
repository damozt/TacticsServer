//
//  HeroController.swift
//  App
//
//  Created by Kevin Damore on 5/18/19.
//

import Vapor
import FluentPostgreSQL

final class HeroController: BaseController {
    
    func getHero(_ req: Request) throws -> Future<DataResponse<Hero>> {
        let heroId = try req.parameters.next(Int.self)
        return Hero.find(heroId, on: req).unwrap(or: Abort(.noContent)).map { DataResponse<Hero>(data: $0) }
    }
    
    func getUserHeroes(_ req: Request) throws -> Future<DataResponse<[Hero]>> {
        
        return req.dispatch { request in
            guard let userId = try self.authenticatedUser(request).wait().id else { throw Abort(.unauthorized) }
            let heroes = try Hero.query(on: req).filter(\.userId, .equal, userId).all().wait()
            return DataResponse<[Hero]>(data: heroes)
        }
    }
    
    func createHero(_ req: Request, data: CreateHero) throws -> Future<DataResponse<Hero>> {
        guard let _ = try authenticatedFirebaseUser(req) else { throw Abort(.unauthorized) }
        return req.dispatch { request in
            let hero = try Hero(id: nil, userId: data.userId, name: data.name, type: data.type, actionIds: "[]").save(on: request).wait()
            return DataResponse<Hero>(data: hero)
        }
    }
}
