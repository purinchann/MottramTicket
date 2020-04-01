//
//  Array+Ext.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import Foundation

extension Array {
    
    func atIndex(_ index: Int) -> Element? {
        
        if index < 0 { return nil }
        guard count > index else { return nil }
        return self[index]
    }
    
    mutating func adding(_ element: Element) -> [Element] {
        
        append(element)
        return Array(self)
    }
    
    // MARK: - 差分計算
    
    func mapBetween<T>(_ execute: (Element, Element) -> T ) -> [T] {
        
        guard count > 1 else { return [] }
        
        var result = [T]()
        
        for i in 0 ..< count - 1 {
            
            result.append( execute(self[i], self[i+1]) )
        }
        
        return result
    }
    
    func forEachBetween(_ execute: (Element, Element) -> Void) {
        
        guard count > 1 else { return }
        
        for i in 0 ..< count - 1 {
            
            execute(self[i], self[i+1])
        }
    }
}
