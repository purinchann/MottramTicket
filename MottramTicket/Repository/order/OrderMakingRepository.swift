//
//  OrderMakingRepository.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/04.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import RxSwift

class OrderMakingRepository {
    
    var cancelIndex = Variable<Int?>(nil)
    let disposeBag = DisposeBag()
    
    func cancelOrder(_ orderId: String, indexRow: Int) {
        
        OrderDataStore().update(orderId, params: ["is_cancel": true]).subscribe(onNext: {[weak self] _ in
            self?.cancelIndex.value = indexRow
            }, onError: {[weak self] _ in
                self?.cancelIndex.value = nil
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}
