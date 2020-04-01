//
//  EventView.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/04.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit

extension UIResponder {
    
    func notify<E: EventView>(_ event: E) {
        
        var responder: UIResponder? = self
        
        while responder != nil {
            
            if let eventType = responder as? E.EventHundler {
                
                event.notify(to: eventType)
                return
            }
            
            responder = responder?.next
        }
    }
}

protocol EventView {
    
    associatedtype EventHundler
    func notify(to handler: EventHundler)
}

// MARK: - スクロールイベント
/* アクションタイプ */
enum ScrollEvent: EventView {
    
    case startEditByKeyBoard(item: UIView)
    
    func notify(to handler: ScrollEventDelegate) {
        
        switch self {
        case let .startEditByKeyBoard(item): handler.scroolAboveOfKeyBoard(item: item)
        }
    }
}

/* イベントプロトコル */
protocol ScrollEventDelegate {
    
    func scroolAboveOfKeyBoard(item: UIView)
}

// MARK: - ----- 以下は使用例 ------

/* アクションタイプ */
enum SomeAction: EventView {
    
    case actionA(UIView)
    case actionB(UIView)
    
    func notify(to handler: SomeNotice) {
        
        switch self {
        case .actionA(let v): handler.noticeA(v)
        case .actionB(let v): handler.noticeB(v)
        }
    }
}

/* イベントプロトコル */
protocol SomeNotice {
    
    func noticeA(_ view: UIView)
    func noticeB(_ view: UIView)
}

class SomeCell: UIView {
    
    func didTap() {
        
        /* ビューからの通知 */
        notify(SomeAction.actionA(self))
    }
}

class SomeViewController: UIViewController, SomeNotice {
    
    func noticeA(_ view: UIView) {
        /* ビューコントローラーでのイベント処理 */
    }
    
    func noticeB(_ view: UIView) {
        /* ビューコントローラーでのイベント処理 */
    }
}
