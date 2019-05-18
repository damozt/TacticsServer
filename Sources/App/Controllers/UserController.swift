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

final class UserController: BaseController {
    
    func getUser(_ req: Request) throws -> Future<DataResponse<PublicUser>> {
        return try authenticatedUser(req).map { DataResponse<PublicUser>(data: $0.publicUser) }
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
        return req.dispatch { request in
            let existingUsers = try User.query(on: req).filter(\.firebaseId, .equal, firebaseUser.sub).all().wait()
            guard existingUsers.count == 0 else { throw Abort(.forbidden, reason: "This user already exists") }
            let newUser = try User(id: nil, firebaseId: firebaseUser.sub, name: data.name, mmr: 1000).save(on: req).wait()
            return DataResponse<PublicUser>(data: newUser.publicUser)
        }
    }
}
