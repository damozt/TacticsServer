//
//  HeroController.swift
//  App
//
//  Created by Kevin Damore on 5/18/19.
//

import Vapor
import FluentPostgreSQL

final class HeroController: BaseController {
    
    override var rootPathString: String {
        return "hero"
    }
    
    func getHero(_ req: Request) throws -> Future<DataResponse<Hero>> {
        return req.dispatch { request in
            
            _ = try self.authenticatedUser(request).wait()
            
            let heroId = try request.parameters.next(Int.self)
            let hero = try Hero.find(heroId, on: req).unwrap(or: Abort(.noContent)).wait()
            
            return DataResponse<Hero>(data: hero)
        }
    }
    
    func getUserHeroes(_ req: Request) throws -> Future<DataResponse<[Hero]>> {
        return req.dispatch { request in
            
            let user = try self.authenticatedUser(request).wait()
            guard let userId = user.id else { throw Abort(.internalServerError) }
            
            let heroes = try Hero.query(on: req).filter(\.userId, .equal, userId).all().wait()
            
            return DataResponse<[Hero]>(data: heroes)
        }
    }
    
    func createHero(_ req: Request, data: CreateHero) throws -> Future<DataResponse<Hero>> {
        return req.dispatch { request in
            
            let user = try self.authenticatedUser(request).wait()
            guard let userId = user.id else { throw Abort(.internalServerError) }
            
            let heroes = try Hero.query(on: req).filter(\.userId, .equal, userId).all().wait()
            guard !heroes.map({ $0.type }).contains(data.type) else { throw Abort(.forbidden, reason: "User already has a hero of this type.") }
            
            let hero = try Hero.newHero(from: data).save(on: request).wait()
            _ = try HeroCustomization.newHeroCustomization(for: hero).save(on: request).wait()
            
            return DataResponse<Hero>(data: hero)
        }
    }
}
