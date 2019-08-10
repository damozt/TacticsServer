//
//  HeroCustomization.swift
//  App
//
//  Created by Kevin Damore on 7/20/19.
//

import Foundation

import Vapor
import FluentPostgreSQL

struct HeroCustomization: PostgreSQLModel {
    
    var id: Int?
    let heroId: Int
    var action0Id: Int?
    var action1Id: Int?
    var action2Id: Int?
    var action3Id: Int?
    
    static func newHeroCustomization(for heroId: Int) -> HeroCustomization {
        return HeroCustomization(
            id: nil,
            heroId: heroId,
            action0Id: nil,
            action1Id: nil,
            action2Id: nil,
            action3Id: nil
        )
    }
}

extension HeroCustomization: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: conn) { (builder) in
            try addProperties(to: builder)
            builder.reference(from: \.heroId, to: \Hero.id, onDelete: ._cascade)
        }
    }
}

extension HeroCustomization: Content {}
extension HeroCustomization: Parameter {}

struct GetHeroCustomization: Content {
    let heroId: Int
}

struct UpdateHeroCustomization: Content {
    
    let id: Int
    let heroId: Int
    let action0Id: Int?
    let action1Id: Int?
    let action2Id: Int?
    let action3Id: Int?
}
