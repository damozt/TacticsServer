//
//  UserController.swift
//  App
//
//  Created by Kevin Damore on 5/7/19.
//

import Vapor
import JWT
import PostgreSQL

final class UserController {
    
    func getUser(_ req: Request) throws -> Future<User> {
        
        guard let bearer = req.http.headers.bearerAuthorization, let firebaseUser = try firebaseUser(withToken: bearer.token) else {
            throw Abort(.unauthorized)
        }
        
        let thing = req.withPooledConnection(to: .psql) { conn in
            return conn.raw("select * from users where id = '\(firebaseUser.sub)'").all(decoding: User.self)
        }
        
        return thing.map { users in
            guard users.count == 1 else { throw Abort(.internalServerError) }
            return users[0]
        }
    }
}

func firebaseUser(withToken token: String) throws -> FirebaseUser? {
    
    let certificate = "-----BEGIN CERTIFICATE-----\nMIIDHDCCAgSgAwIBAgIIUMP42NVztVgwDQYJKoZIhvcNAQEFBQAwMTEvMC0GA1UE\nAxMmc2VjdXJldG9rZW4uc3lzdGVtLmdzZXJ2aWNlYWNjb3VudC5jb20wHhcNMTkw\nNDI2MjEyMDUxWhcNMTkwNTEzMDkzNTUxWjAxMS8wLQYDVQQDEyZzZWN1cmV0b2tl\nbi5zeXN0ZW0uZ3NlcnZpY2VhY2NvdW50LmNvbTCCASIwDQYJKoZIhvcNAQEBBQAD\nggEPADCCAQoCggEBAJNqQOgxyrXbV2GoD5JI5DzFJBFFaQJ5BCdcSRl2L1TKQ8OK\nXOzvf/nu+hHblTWMmyHDS1jI4dvGdttI/sua7RaeVcXFFaY3UDWspY8vlsc3cuam\npH1NYYTGh0xDquKdmwytjdVpJQ0TW8LrJKuB0OzToyl/IdbgU4F6av/fO1AAosV9\n5RNQ7Y2XjI93yKFmPThXLCo1F0eGlpX2bWbXE7KIBjgsyDIBcL7rBAjvfrLv8oX7\nI4XV3YM3Wq/JbbseQ3coircKMo7j3Cfzax9XwZjpz8kTSkwVhDcS4+7gSx/aBQAs\n6F9NG0+2NDfdBigRwOHpPzc8WfzWHSco/mWY1f0CAwEAAaM4MDYwDAYDVR0TAQH/\nBAIwADAOBgNVHQ8BAf8EBAMCB4AwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwIwDQYJ\nKoZIhvcNAQEFBQADggEBABSpUhzrpTth+G5y/+5qPWT43v/NgD7qMFVgbcjy0gNl\n0scae+M7c/J8WzX2EOIhETnItvgo/mYihDeACHTqApeDXGczL88gpT1hjPdfm3Qi\niyFBUc+N4XR4nMreyC51nYJWPjMvPFDv0HxmgTMq2W7QyOKOFjDPxTJj42V9OL+M\nkCuNCssMVOIjmxDmQ4ig1Ni4IVovhZOsTswbzmq20I0Aqnp0iH/LyUG6e2zr1i1u\ngz+xjswyRRl1WrF9HSuoihVgRwXSjHSkMIG33k3sb2KYvk5rHhuCML8UnPyG6vv0\n7B6GEvTEKYEQ7Rvkp6DR07uLtCJk2TxxrGO8j/CLayw=\n-----END CERTIFICATE-----"
    let firebaseUser = try JWT<FirebaseUser>(from: token, verifiedUsing: .rs256(key: .public(certificate: certificate))).payload
    
    let now = Date()
    let projectId = "for-glory-tactics-dev"
    
    if Date(timeIntervalSince1970: firebaseUser.auth_time) > now {
        throw Abort(.unauthorized, reason: "Invalid Auth time")
    }

    if Date(timeIntervalSince1970: firebaseUser.iat) > now {
        throw Abort(.unauthorized, reason: "Invalid Issued-at time")
    }

    if Date(timeIntervalSince1970: firebaseUser.exp) < now {
        throw Abort(.unauthorized, reason: "Token expired")
    }
    
    if firebaseUser.aud != projectId {
        throw Abort(.unauthorized, reason: "Invalid Audience")
    }
    
    if firebaseUser.iss != "https://securetoken.google.com/\(projectId)" {
        throw Abort(.unauthorized, reason: "Invalid Issuer")
    }
    
    return firebaseUser
}
