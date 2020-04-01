//
//  UILabel+Ext.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/03.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit

extension UILabel {
    
    @IBInspectable var isAdjust: Bool {
        get {
            return false
        }
        set {
            if newValue {
                adjustsFontSizeToFitWidth = true
            }
        }
    }
}
