//
//  Request+Extensions.swift
//  App
//
//  Created by Kevin Damore on 5/10/19.
//

import Vapor

extension Request {
    
    func authenticate() throws -> FirebaseUser? {
        
        guard let bearer = http.headers.bearerAuthorization else { throw Abort(.unauthorized) }
        
        func decode(jwtToken jwt: String) -> [Data?] {
            let segments = jwt.components(separatedBy: ".")
            return segments.map { base64UrlDecode($0) }
        }
        
        func base64UrlDecode(_ value: String) -> Data? {
            var base64 = value.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
            
            let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
            let requiredLength = 4 * ceil(length / 4.0)
            let paddingLength = requiredLength - length
            if paddingLength > 0 {
                let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
                base64 = base64 + padding
            }
            return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
        }
        
        let decoded = decode(jwtToken: bearer.token)
        guard
            //        let headerData = decoded[0],
            let payloadData = decoded[1] else { //TODO: MAKE SAFE ARRAY INDEXING: decoded[safe: 1]
                throw Abort(.unauthorized, reason: "Invalid token")
        }
        
        let firebaseUser = try JSONDecoder().decode(FirebaseUser.self, from: payloadData)
        
            let now = Date()
            let projectId = "for-glory-tactics-dev"
        
            if Date(timeIntervalSince1970: firebaseUser.auth_time) > now {
                throw Abort(.unauthorized, reason: "Invalid Auth time")
            }
            
            if Date(timeIntervalSince1970: firebaseUser.iat) > now {
                throw Abort(.unauthorized, reason: "Invalid Issued-at time")
            }
        //
        //    if Date(timeIntervalSince1970: firebaseUser.exp) < now {
        //        throw Abort(.unauthorized, reason: "Token expired")
        //    }
        
            if firebaseUser.aud != projectId {
                throw Abort(.unauthorized, reason: "Invalid Audience")
            }
        
            if firebaseUser.iss != "https://securetoken.google.com/\(projectId)" {
                throw Abort(.unauthorized, reason: "Invalid Issuer")
            }
        
        return firebaseUser
    }
    
    //    first attempt at this. issue is the google certificate. there are 2 public certs that are based off kid, but I need to decode the header of the JWT to get the kid...doable, but just a pain
    //    let certificate = "-----BEGIN CERTIFICATE-----\nMIIDHDCCAgSgAwIBAgIIWtSKoLQPMUQwDQYJKoZIhvcNAQEFBQAwMTEvMC0GA1UE\nAxMmc2VjdXJldG9rZW4uc3lzdGVtLmdzZXJ2aWNlYWNjb3VudC5jb20wHhcNMTkw\nNTA0MjEyMDUxWhcNMTkwNTIxMDkzNTUxWjAxMS8wLQYDVQQDEyZzZWN1cmV0b2tl\nbi5zeXN0ZW0uZ3NlcnZpY2VhY2NvdW50LmNvbTCCASIwDQYJKoZIhvcNAQEBBQAD\nggEPADCCAQoCggEBAMetajqTxyFJduJc2qyK+uA8ON6ST5sL2/ujzL+7QZtu+17f\nQFZggvpOScyO152g0JOlTJkts0yHedxm9Ijr085v7GmSxzO7dm+g3gP1t0lxa8dr\nCHDpLBIpQG4qP+GyJtnWM3wEpu7XZ4bJPtiWZsgEb6sWxGJ7iXryZc+SWG8vH75/\nsMdZw4jwNyewsa11b054dLyywPVoH0BT1eDL0oXq+GB18wiWeL+13CBYMr9EIFDz\norNG6bP/LYfJNbudlcUi1CMDX4imXSp0d6LEITMdwzGk6yg3s39BGH3AqJqBhFO0\nDTDv6dDKAmC5u3OGm+oXiPhKtoocDOkoHevMndcCAwEAAaM4MDYwDAYDVR0TAQH/\nBAIwADAOBgNVHQ8BAf8EBAMCB4AwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwIwDQYJ\nKoZIhvcNAQEFBQADggEBALD1mBXBIemcICDhmj3zgTY6RU7Xe7TWMn8Duszgmffh\n974AtYsshiDGrGxW96gIZdGZqs9djmQDdsX6La/DKzWYsbsTn5sm+alzQE74UrU5\nJTLklcWEjn9ztqVirIpj9gn4OQDNrnQPlGZcXcJffd5dQaZt+eZNLIBfNeLss+OM\nMAPCoW46VlXVtaGi/Mwt/qX3Up4HkpKeh6Tr6+9NiFepBetgSzi1FReZc3e+GjxA\nctXGPMmvGnQB+XCNGHoNUNYuKHkgBCFQUsqxr1Bk3om5RxzKLXA1sZgleLMVNaTj\nWz7AlrZbotidBIiwL/ejCEczuN9e4xKnz25hL9ApQTk=\n-----END CERTIFICATE-----\n"
    //    let firebaseUser = try JWT<FirebaseUser>(from: token, verifiedUsing: .rs256(key: .public(certificate: certificate))).payload
}
