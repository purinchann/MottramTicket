//
//  Cart.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/03.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import Foundation

struct Cart {
    var id: String?
    var userId: String?
    var menuName: String?
    var price: Int?
    var size: String?
    var createdAt: Double?
    var menuId: String?
    var shopId: String?
    var isOrder: Bool?
    var imageUrl: String?
    
    init(dic: [String: Any]) {
        self.id = dic["id"] as? String
        self.userId = dic["user_id"] as? String
        self.menuName = dic["menu_name"] as? String
        self.price = dic["price"] as? Int
        self.size = dic["size"] as? String
        self.createdAt = dic["created_at"] as? Double
        self.menuId = dic["menu_id"] as? String
        self.shopId = dic["shop_id"] as? String
        self.isOrder = dic["is_order"] as? Bool
        self.imageUrl = dic["image_url"] as? String
    }
}
