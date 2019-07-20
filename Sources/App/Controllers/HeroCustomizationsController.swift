//
//  HeroCustomizationsController.swift
//  App
//
//  Created by Kevin Damore on 7/20/19.
//

import Vapor
import FluentPostgreSQL

final class HeroCustomizationsController: BaseController {
    
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
    
    func updateHeroCustomization(_ req: Request, data: UpdateHeroCustomization) throws -> Future<DataResponse<HeroCustomization>> {
        return req.dispatch { request in

            let user = try self.authenticatedUser(request).wait()
            var heroCustomization = try HeroCustomization.find(data.id, on: request).unwrap(or: Abort(.badRequest, reason: "No HeroCustomization with id: \(data.id)")).wait()
            guard heroCustomization.heroId == data.heroId else { throw Abort(.forbidden, reason: "HeroId mismatch") }
            let hero = try Hero.find(data.heroId, on: request).unwrap(or: Abort(.forbidden, reason: "No hero exists with id: \(data.heroId)")).wait()
            guard hero.userId == user.id else { throw Abort(.forbidden, reason: "This user cannot update this hero customization") }
            
            heroCustomization.equippedActionIds = data.equippedActionIds
            heroCustomization.skinId = data.skinId
            heroCustomization.rightHandId = data.rightHandId
            heroCustomization.leftHandId = data.leftHandId
            heroCustomization.accessoryId = data.accessoryId
            
            let updatedHeroCustomization = try heroCustomization.save(on: request).wait()
            
            return DataResponse<HeroCustomization>(data: updatedHeroCustomization)
        }
    }
}
