//
//  DateUtil.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/06.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import Foundation

class DateUtil {
    
    func stringToDate(_ format: String, dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: dateStr) else {return Date()}
        return date
    }
}
