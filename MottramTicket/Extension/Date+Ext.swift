//
//  Date+Ext.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    
    func convertFormat(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func clacDate(_ dayInt: Int) -> Date {
        
        if 0 < dayInt {
            return Date(timeInterval: TimeInterval(60*60*24*dayInt), since: self)
        } else {
            return Date(timeInterval: TimeInterval(-60*60*24*dayInt), since: self)
        }
    }
    
    func spanFormat() -> String {
        let spanInterval = timeIntervalSinceNow
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.day, .hour, .minute]
        let outputString =  formatter.string(from: spanInterval) ?? ""
        return outputString.replacingOccurrences(of: "-", with: "")
    }
}

