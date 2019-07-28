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
    var abilityIds: String
    var skinId: Int
    var skinColor: String
    var hairStyleId: Int
    var hairColor: String
    var mainHandId: Int
    var offHandId: Int
    
    static func newHeroCustomization(for heroId: Int) -> HeroCustomization {
        return HeroCustomization(id: nil, heroId: heroId, abilityIds: "[]", skinId: 0, skinColor: "FFFFFF", hairStyleId: 0, hairColor: "000000", mainHandId: 0, offHandId: 0)
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
    let abilityIds: String
    let skinId: Int
    let skinColor: String
    let hairStyleId: Int
    let hairColor: String
    let mainHandId: Int
    let offHandId: Int
}
