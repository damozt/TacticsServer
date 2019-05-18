//
//  BaseController.swift
//  App
//
//  Created by Kevin Damore on 5/18/19.
//

import Vapor
import FluentPostgreSQL

class BaseController {
    
    func authenticatedUser(_ req: Request) throws -> Future<User> {
        guard let firebaseUser = try req.authenticate() else { throw Abort(.unauthorized) }
        let users = User.query(on: req).filter(\.firebaseId, .equal, firebaseUser.sub).all()
        return users.map { users in
            guard users.count > 0 else { throw Abort(.noContent, reason: "No users found.") }
            guard users.count == 1 else { throw Abort(.internalServerError) }
            return users[0]
        }
    }
}
