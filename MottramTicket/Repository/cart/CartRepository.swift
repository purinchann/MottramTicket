//
//  CartRepository.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/04.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import Foundation
import RxSwift

class CartRepository {
    
    var cartList = Variable<[Cart]>([])
    var shop = Variable<Shop?>(nil)
    var deleteIndex = Variable<Int?>(nil)
    var isCreateOrder = Variable<Bool?>(nil)
    private var disposeBag = DisposeBag()
    
    func fetchShop(shopId: String) {
        
        ShopDataStore().findById(id: shopId).subscribe(onNext: {[weak self] shop in
            self?.shop.value = shop
            }, onError: {[weak self] error in
                self?.shop.value = nil
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func fetchList() {
        
        guard let userId = AuthDataStore.shared.currentUser.value?.id else { return }
        CartDataStore().whereByUserId(userId).subscribe(onNext: {[weak self] carts in
                self?.cartList.value = carts.filter{ !($0.isOrder ?? true) }
            }, onError: {[weak self] error in
                self?.cartList.value = []
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    // カートの削除
    func deleteCart(cartId: String, indexRow: Int) {
        CartDataStore().delete(cartId).subscribe(onNext: {[weak self] isResult in
                self?.deleteIndex.value = indexRow
            }, onError: {[weak self] error in
                self?.deleteIndex.value = nil
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    // カートの更新 &  オーダーの登録
    func createOrder(cnt: Int, carts: [Cart]) {
        
        guard let userId = AuthDataStore.shared.currentUser.value?.id else { return }
        let timestamp = Double(Date().timeIntervalSince1970)*1000
        let orderMonth = Date().convertFormat("yyyyMM")
        let orderDateStr = Date().convertFormat("yyyyMMdd")
        let orderTimeStr = Date().convertFormat("yyyyMMddHHmm")
        
        guard let cart = carts.atIndex(cnt),
            let cartId = cart.id else {return}
        
        let params: [String: Any] = [
            "user_id": userId,
            "order_name": cart.menuName ?? "",
            "price": cart.price ?? 0,
            "size": cart.size ?? "",
            "created_at": timestamp,
            "updated_at": timestamp,
            "is_paid": false,
            "is_make": false,
            "is_complete": false,
            "is_cancel": false,
            "order_month": orderMonth,
            "order_date": orderDateStr,
            "order_time": orderTimeStr,
            "menu_id": cart.menuId ?? "",
            "shop_id": cart.shopId ?? ""
        ]
        
        if  0 < cnt {
            //もう一回
            updateCart(cartId, completed: { isCmp in
                if isCmp {
                    OrderDataStore().add(params).subscribe(onNext: {[weak self] isResult in
                        self?.createOrder(cnt: cnt - 1, carts: carts)
                        }, onError: {[weak self] error in
                            self?.isCreateOrder.value = false
                        }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
                } else {
                    self.isCreateOrder.value = false
                }
            })
        } else {
            updateCart(cartId, completed: { isCmp in
                if isCmp {
                    OrderDataStore().add(params).subscribe(onNext: {[weak self] isResult in
                        self?.isCreateOrder.value = true
                        }, onError: {[weak self] error in
                            self?.isCreateOrder.value = false
                        }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
                } else {
                    self.isCreateOrder.value = false
                }
            })
        }
    }
    
    private func updateCart(_ cartId: String, completed: @escaping ((Bool) -> Void)) {
        CartDataStore().updateByIsOrder(cartId).subscribe(onNext: { _ in
            completed(true)
            }, onError: { _ in
                completed(false)
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}
