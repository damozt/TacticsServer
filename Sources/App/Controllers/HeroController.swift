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
        let userId = try req.parameters.next(Int.self)
        return Hero.query(on: req).filter(\.userId, .equal, userId).all().map { DataResponse<[Hero]>(data: $0) }
    }
    
    func createHero(_ req: Request, data: CreateHero) throws -> Future<Hero> {
        guard let _ = try req.authenticate() else { throw Abort(.unauthorized) }
        return Hero(id: nil, userId: 0, name: "asd", type: 0, actionIds: "[]").save(on: req)
//        return Hero.newHero(from: data).save(on: req)
    }
}
