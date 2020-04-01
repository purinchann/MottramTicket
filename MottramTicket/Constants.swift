//
//  Constants.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit

struct Constants {
    
    struct Time {
        static let imageCache: TimeInterval = 60 * 5
        static let minutes1: TimeInterval = 60
        static let minutes30: TimeInterval = 60 * 30
        static let hour1: TimeInterval = 60 * 60
        static let day1: TimeInterval = 60 * 60 * 24
        static let day3: TimeInterval = 60 * 60 * 24 * 3
    }
    
    struct Size {
        static let maxMemoryCost: UInt = 20 * 1024 * 1024
        static let maxDiskCacheSize: UInt = 20 * 1024 * 1024
        static let searchBarHeight: CGFloat = 44
    }
}
