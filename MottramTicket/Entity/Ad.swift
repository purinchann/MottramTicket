//
//  Ad.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/03.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import Foundation

struct Ad {
    var bannarImageUrl: String?
    var pageUrl: String?
    
    init(dic: [String: Any]) {
        self.bannarImageUrl = dic["banner_image_url"] as? String
        self.pageUrl = dic["page_url"] as? String
    }
}
