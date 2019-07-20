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
    let heroId: Int?
    var equippedActionIds: String
    var skinId: Int
    var leftHandId: Int
    var rightHandId: Int
    var accessoryId: Int
    
    static func newHeroCustomization(for hero: Hero) -> HeroCustomization {
        return HeroCustomization(id: nil, heroId: hero.id, equippedActionIds: "[]", skinId: 0, leftHandId: 0, rightHandId: 0, accessoryId: 0)
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
    let equippedActionIds: String
    let skinId: Int
    let leftHandId: Int
    let rightHandId: Int
    let accessoryId: Int
}
