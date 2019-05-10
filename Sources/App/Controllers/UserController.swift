//
//  UserController.swift
//  App
//
//  Created by Kevin Damore on 5/7/19.
//

import Vapor
import JWT
import PostgreSQL
import FluentPostgreSQL

final class UserController {
    
    func getUser(_ req: Request) throws -> Future<PublicUser> {
        guard let firebaseUser = try req.authenticate() else { throw Abort(.unauthorized) }
        let users = User.query(on: req).filter(\.firebaseId, .equal, firebaseUser.sub).all()
        return users.map { users in
            guard users.count == 1 else { throw Abort(.internalServerError) }
            return PublicUser(user: users[0])
        }
    }
    
    func getAllUsers(_ req: Request) throws -> Future<[PublicUser]> {
        return User.query(on: req).all().map { $0.map { PublicUser(user: $0) } }
    }
    
    func findUsersWithName(_ req: Request) throws -> Future<[PublicUser]> {
        let name = try req.query.get(String.self, at: "name")
        return User.query(on: req).filter(\.name, .ilike, name).all().map { $0.map { PublicUser(user: $0) } }
    }
    
    func createUser(_ req: Request, data: CreateUser) throws -> Future<PublicUser> {
        guard let firebaseUser = try req.authenticate() else { throw Abort(.unauthorized) }
        
        let existingUsers = User.query(on: req).filter(\.firebaseId, .equal, firebaseUser.sub).count()
        print(existingUsers)
        
        let user = User(id: nil, firebaseId: firebaseUser.sub, name: data.name, mmr: 1000)
        return user.save(on: req).map { newUser in
            return PublicUser(user: newUser)
        }
    }
}
