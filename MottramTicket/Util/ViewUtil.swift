//
//  ViewUtil.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/03.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit

class ViewUtil: NSObject {
    
    static let shared = ViewUtil()
    
    func getScreenSize() -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    func getScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    func getHeightForAspectRatio(multiplier: CGFloat) -> CGFloat {
        let width = getScreenWidth()
        let height = width * multiplier
        return height
    }
}
