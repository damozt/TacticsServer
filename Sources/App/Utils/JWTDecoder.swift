//
//  FGJWT.swift
//  App
//
//  Created by Kevin Damore on 5/8/19.
//

import Foundation

class JWTDecoder {
    
    func decode2(jwtToken jwt: String) -> [Data?] {
        let segments = jwt.components(separatedBy: ".")
        return segments.map { base64UrlDecode($0) }
    }
    
    private func base64UrlDecode(_ value: String) -> Data? {
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
}
