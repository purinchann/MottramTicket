//
//  User.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

struct User: Codable {
    
    var id: String?
    var mail: String?
    var role: Int?
    
    init(dic: [String: Any]) {
        self.id = dic["id"] as? String
        self.mail = dic["mail"] as? String
        self.role = dic["role"] as? Int
    }
}

