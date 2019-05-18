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
    
    func getUser(_ req: Request) throws -> Future<DataResponse<PublicUser>> {
        guard let firebaseUser = try req.authenticate() else { throw Abort(.unauthorized) }
        let users = User.query(on: req).filter(\.firebaseId, .equal, firebaseUser.sub).all()
        
        return users.map { users in
            guard users.count > 0 else { throw Abort(.noContent, reason: "No users found.") }
            guard users.count == 1 else { throw Abort(.internalServerError) }
            return users[0].publicUser
        }.map {
            return DataResponse<PublicUser>(data: $0)
        }
    }
    
    func getAllUsers(_ req: Request) throws -> Future<DataResponse<[PublicUser]>> {
        return User.query(on: req).all().map { $0.map { $0.publicUser } }.map { DataResponse<[PublicUser]>(data: $0) }
    }
    
    func findUsersWithName(_ req: Request) throws -> Future<DataResponse<[PublicUser]>> {
        let name = try req.query.get(String.self, at: "name")
        return User.query(on: req).filter(\.name, .ilike, name).all().map { $0.map { $0.publicUser } }.map { DataResponse<[PublicUser]>(data: $0) }
    }
    
    func createUser(_ req: Request, data: CreateUser) throws -> Future<DataResponse<PublicUser>> {
        guard let firebaseUser = try req.authenticate() else { throw Abort(.unauthorized) }
        
        let existingUsers = User.query(on: req).filter(\.firebaseId, .equal, firebaseUser.sub).count()
        print(existingUsers) //TODO: make sure this user has not been added already
        
        let user = User(id: nil, firebaseId: firebaseUser.sub, name: data.name, mmr: 1000)
        return user.save(on: req).map { $0.publicUser }.map { DataResponse<PublicUser>(data: $0) }
    }
}
