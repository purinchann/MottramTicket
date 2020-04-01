//
//  Menu.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import Foundation

struct Menu {
    var id: String?
    var nameJp: String?
    var nameEn: String?
    var priceAndSize: String? //カンマ区切り 例) M490,L590
    var imageUrl: String?
    var handlingShopNumber: String? //カンマ区切り 例) 1,2,3,4
    var orderLimit: String?
    var seasonLimit: String? //* 例) 4・5月限定 *//
    var isSoldOut: Bool?
    
    init(dic: [String: Any]) {
        self.id = dic["id"] as? String
        self.nameJp = dic["name_jp"] as? String
        self.nameEn = dic["name_en"] as? String
        self.priceAndSize = dic["price_and_size"] as? String
        self.imageUrl = dic["image_url"] as? String
        self.handlingShopNumber = dic["handling_shop_number"] as? String
        self.orderLimit = dic["order_limit"] as? String
        self.seasonLimit = dic["season_limit"] as? String
        self.isSoldOut = dic["is_sold_out"] as? Bool
    }
}
