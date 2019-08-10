//
//  HeroCustomizationController.swift
//  App
//
//  Created by Kevin Damore on 7/20/19.
//

import Vapor
import FluentPostgreSQL

final class HeroCustomizationController: BaseController {
    
    override var rootPathString: String {
        return "heroCustomization"
    }
    
    func getHeroCustomizations(_ req: Request) throws -> Future<DataResponse<[HeroCustomization]>> {
        return req.dispatch { request in
            
            _ = try self.authenticatedUser(request).wait()
            
            let heroId = try request.parameters.next(Int.self)
            let heroCustomizations = try HeroCustomization.query(on: request).filter(\.heroId, .equal, heroId).all().wait()
            
            return DataResponse<[HeroCustomization]>(data: heroCustomizations)
        }
    }
    
    func createHeroCustomization(_ req: Request) throws -> Future<DataResponse<HeroCustomization>> {
        return req.dispatch { request in
            var user = try self.authenticatedUser(request).wait()
            
            guard user.currency > Cost.newHeroCustomization else { throw Abort(.forbidden, reason: "User doesn't have enough gold (TODO: currency name?)") }
            
            let heroId = try request.parameters.next(Int.self)
            
            let heroCustomizations = try HeroCustomization.query(on: request).filter(\.heroId, .equal, heroId).all().wait()
            guard heroCustomizations.count < 3 else { throw Abort(.forbidden, reason: "Cannot have more than 3 customizations") }
            
            let heroCustomization = try HeroCustomization.newHeroCustomization(for: heroId).save(on: request).wait()
            
            user.currency -= Cost.newHeroCustomization
            _ = user.save(on: request)
            
            return DataResponse<HeroCustomization>(data: heroCustomization)
        }
    }
    
    func updateHeroCustomization(_ req: Request, data: UpdateHeroCustomization) throws -> Future<DataResponse<HeroCustomization>> {
        return req.dispatch { request in

            let user = try self.authenticatedUser(request).wait()
            var heroCustomization = try HeroCustomization.find(data.id, on: request).unwrap(or: Abort(.badRequest, reason: "No HeroCustomization with id: \(data.id)")).wait()
            guard heroCustomization.heroId == data.heroId else { throw Abort(.forbidden, reason: "HeroId mismatch") }
            let hero = try Hero.find(data.heroId, on: request).unwrap(or: Abort(.forbidden, reason: "No hero exists with id: \(data.heroId)")).wait()
            guard hero.userId == user.id else { throw Abort(.forbidden, reason: "This user cannot update this hero customization") }
            
            heroCustomization.action0Id = data.action0Id
            heroCustomization.action1Id = data.action1Id
            heroCustomization.action2Id = data.action2Id
            heroCustomization.action3Id = data.action3Id
            
            let updatedHeroCustomization = try heroCustomization.save(on: request).wait()
            
            return DataResponse<HeroCustomization>(data: updatedHeroCustomization)
        }
    }
}
