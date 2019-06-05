//
//  PurchaseRepository.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/05.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import RxSwift

class PurchaseRepository {
    
    var orderList = Variable<[Order]>([])
    var selectIndex = Variable<Int?>(nil)
    private let disposeBag = DisposeBag()
    
    func fetchList() {
        
        let todayStr = Date().convertFormat("yyyyMMdd")
        OrderDataStore().whereByTodayOrder(dateStr: todayStr).subscribe(onNext: {[weak self] orders in
            self?.orderList.value = orders
            }, onError: {[weak self] error in
                self?.orderList.value = []
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func purchaseComplete(orderId: String, orderName: String, customerId: String, indexRow: Int) {
        
        guard let userId = AuthDataStore.shared.currentUser.value?.id else {return}
        let timestamp = Double(Date().timeIntervalSince1970)*1000
        
        let params: [String: Any] = [
            "is_make": true,
            "updated_at": timestamp,
            "buyerId": userId
        ]
        OrderDataStore().update(orderId, params: params).subscribe(onNext: {[weak self] _ in
            
            guard let `self` = self else {return}
            let messageMonth = Date().convertFormat("yyyyMM")
            let messageDateStr = Date().convertFormat("yyyyMMdd")
            let messageTimeStr = Date().convertFormat("yyyyMMddHHmm")
            let timestamp = Double(Date().timeIntervalSince1970)*1000
            
            let messageParams: [String: Any] = [
                "message_text": "ご注文いただいた\(orderName)を手に入れました。受け取りにお越しください。",
                "user_id": customerId,
                "is_watch": false,
                "message_month": messageMonth,
                "message_date": messageDateStr,
                "message_time": messageTimeStr,
                "created_at": timestamp
            ]
            
            MessageDataStore().add(messageParams).subscribe(onNext: {[weak self] _ in
                    guard let `self` = self else {return}
                    self.selectIndex.value = indexRow
                }, onError: {[weak self] _ in
                    guard let `self` = self else {return}
                    self.selectIndex.value = nil
                }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        }, onError: {[weak self] _ in
            self?.selectIndex.value = nil
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}
