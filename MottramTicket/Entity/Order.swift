//
//  Order.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/04.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import Foundation

struct Order {
    var id: String?
    var userId: String?
    var orderName: String?
    var price: Int?
    var size: String?
    var createdAt: Double?
    var updatedAt: Double?
    var isPaid: Bool?
    var isMake: Bool?
    var isComplete: Bool?
    var isCancel: Bool?
    var orderMonth: String?
    var orderDate: String?
    var orderTime: String?
    var menuId: String?
    var shopId: String?
    var imageUrl: String?
    
    init(dic: [String: Any]) {
        self.id = dic["id"] as? String
        self.userId = dic["user_id"] as? String
        self.orderName = dic["order_name"] as? String
        self.price = dic["price"] as? Int
        self.size = dic["size"] as? String
        self.createdAt = dic["created_at"] as? Double
        self.updatedAt = dic["updated_at"] as? Double
        self.isPaid = dic["is_paid"] as? Bool
        self.isMake = dic["is_make"] as? Bool
        self.isComplete = dic["is_complete"] as? Bool
        self.isCancel = dic["is_cancel"] as? Bool
        self.orderMonth = dic["order_month"] as? String
        self.orderDate = dic["order_date"] as? String
        self.orderTime = dic["order_time"] as? String
        self.menuId = dic["menu_id"] as? String
        self.shopId = dic["shop_id"] as? String
        self.imageUrl = dic["image_url"] as? String
    }
}
