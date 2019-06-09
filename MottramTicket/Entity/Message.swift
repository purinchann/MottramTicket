//
//  Message.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/05.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import Foundation

struct Message {
    var id: String?
    var messageSubject: String?
    var messageText: String?
    var messageMonth: String?
    var messageDate: String?
    var messageTime: String?
    var createdAt: Double?
    var userId: String?
    var isWatch: Bool?
    
    init(dic: [String: Any]) {
        self.id = dic["id"] as? String
        self.messageSubject = dic["message_subject"] as? String
        self.messageText = dic["message_text"] as? String
        self.messageMonth = dic["message_month"] as? String
        self.messageDate = dic["message_date"] as? String
        self.messageTime = dic["message_time"] as? String
        self.createdAt = dic["created_at"] as? Double
        self.userId = dic["user_id"] as? String
        self.isWatch = dic["is_watch"] as? Bool

    }
}
