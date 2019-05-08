//
//  FirebaseUser.swift
//  App
//
//  Created by Kevin Damore on 5/8/19.
//

import Foundation
import JWT

struct FirebaseUser: JWTPayload {
    
    var iss: String
    var aud: String
    var auth_time: TimeInterval
    var sub: String
    var iat: TimeInterval
    var exp: TimeInterval
    var email: String
    var email_verified: Bool
    
    func verify(using signer: JWTSigner) throws {
    }
}
