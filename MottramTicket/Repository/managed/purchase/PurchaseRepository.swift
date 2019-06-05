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
    
    func purchaseComplete(orderId: String, indexRow: Int) {
        
        guard let userId = AuthDataStore.shared.currentUser.value?.id else {return}
        let timestamp = Double(Date().timeIntervalSince1970)*1000
        
        // お客さんにメッセージも連動して送りたい
        let params: [String: Any] = [
            "is_make": true,
            "updated_at": timestamp,
            "buyerId": userId
        ]
        OrderDataStore().update(orderId, params: params).subscribe(onNext: {[weak self] _ in
            self?.selectIndex.value = indexRow
        }, onError: {[weak self] _ in
            self?.selectIndex.value = nil
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}
