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
    
    func isInBusinessHours(startStr: String, endStr: String) -> Bool {
        
        let nowStr = self.convertFormat("HH:mm:ss")
        if startStr <= nowStr && nowStr <= endStr {
            return true
        } else {
            return false
        }
    }
    
    func elapsedTimeStr(unixtime: Int) -> String {
        
        let startDate = Date(timeIntervalSince1970: TimeInterval(unixtime/1000))
        let timeInterval = Date().timeIntervalSince(startDate)
        
        let secondTime = Double(timeInterval)
        
        var calender = Calendar.current
        calender.locale = Locale(identifier: "ja_JP")
        
        switch secondTime {
        case 0 ..< Constants.Time.minutes1:
            let second = calender.dateComponents([.second], from: startDate, to: Date()).second ?? 0
            let secondStr = String(second)
            return "\(secondStr)" + "秒前"
        case 0 ..< Constants.Time.hour1:
            let minitu = calender.dateComponents([.minute], from: startDate, to: Date()).minute ?? 0
            let minituStr = String(minitu)
            return "\(minituStr)" + "分前"
        case 0 ..< Constants.Time.day1:
            let hour = calender.dateComponents([.hour], from: startDate, to: Date()).hour ?? 0
            let hourStr = String(hour)
            return "\(hourStr)" + "時間前"
        case 0 ..< Constants.Time.day3:
            let day = calender.dateComponents([.day], from: startDate, to: Date()).day ?? 0
            let dayStr = String(day)
            return "\(dayStr)" + "日前"
        default:
            let epocTime = unixtime / 1000
            let timestampDate = Date(timeIntervalSince1970: TimeInterval(epocTime))
            return timestampDate.convertFormat("yyyy/MM/dd")
        }
    }
}

