//
//  FCM.swift
//  App
//
//  Created by Kevin Damore on 7/15/19.
//

import Foundation

class FCM {
    
    #if DEBUG
    let apiKey = "AIzaSyCwjKMv7kuyTh5X3bHzjYXYY416uF2W2Tw"
    #else
    let apiKey = "AIzaSyCwjKMv7kuyTh5X3bHzjYXYY416uF2W2Tw"
    #endif
    
    struct FCMMessage: Encodable {
        let to: String
        let notification: FCMNotification
        let data: BattleNotificationData
        let priority: String
    }
    
    struct FCMNotification: Encodable {
        let title: String?
        let body: String?
        let badge: Int
        let click_action: String
        let sound: String
    }
    
    struct BattleNotificationData: Encodable {
        let battleId: Int
    }
    
    let message: FCMMessage
    
    init(to: String, title: String?, body: String, battleId: Int) {
        let notification = FCMNotification(title: title, body: body, badge: 1, click_action: "goToBattle", sound: "battle")
        let data = BattleNotificationData(battleId: battleId)
        self.message = FCMMessage(to: to, notification: notification, data: data, priority: "normal")
    }
    
    func send() {
        
        let urlString = "https://fcm.googleapis.com/fcm/send"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            
            request.setValue("key=\(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpMethod = "POST"
            request.httpBody = try? JSONEncoder().encode(message)
            
            URLSession.shared.dataTask(with: request).resume()
            
        } else {
            print("log error")
        }
    }
}
