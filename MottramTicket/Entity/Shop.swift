//
//  Shop.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import Foundation

struct Shop {
    var id: String?
    var name: String?
    var number: Int?
    var city: String?
    var address: String?
    var postalCode: String?
    var currentWaitTime: Int?
    var fee: Int?
    var orderLimit: Int?
    var businessHours: String?
    var tel: String?
    
    init(dic: [String: Any]) {
        self.id = dic["id"] as? String
        self.name = dic["name"] as? String
        self.number = dic["number"] as? Int
        self.city = dic["city"] as? String
        self.address = dic["address"] as? String
        self.postalCode = dic["postal_code "] as? String
        self.currentWaitTime = dic["current_wait_time"] as? Int
        self.fee = dic["fee"] as? Int
        self.orderLimit = dic["order_limit"] as? Int
        self.businessHours = dic["business_hours"] as? String
        self.tel = dic["tel"] as? String
    }
}
