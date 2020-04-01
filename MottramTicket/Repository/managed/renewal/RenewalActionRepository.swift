//
//  RenewalActionRepository.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/05.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import RxSwift

class RenewalActionRepository {
    
    var oderAndShopPair = Variable<(order: Order, shop: Shop)?>(nil)
    var isUpdateResult = Variable<Bool?>(nil)
    private let disposeBag = DisposeBag()
    
    func fetchOrder(orderId: String) {
        
        OrderDataStore().findById(id: orderId).subscribe(onNext: { [weak self] order in
            guard let `self` = self, let shopId = order.shopId else {
                return
            }
            ShopDataStore().findById(id: shopId).subscribe(onNext: { [weak self] shop in
                    self?.oderAndShopPair.value = (order: order, shop: shop)
                }, onError: { [weak self] _ in
                    self?.oderAndShopPair.value = nil
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        }, onError: { [weak self] _ in
            self?.oderAndShopPair.value = nil
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func updateOrder(orderId: String, params: [String: Any]) {
        OrderDataStore().update(orderId, params: params).subscribe(onNext: {[weak self] _ in
                self?.isUpdateResult.value = true
            }, onError: {[weak self] _ in
                self?.isUpdateResult.value = nil
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}
