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
        
        if let userId = AuthDataStore.shared.currentUser.value?.id {
            CartDataStore().whereByUserId(userId).subscribe(onNext: {[weak self] carts in
                self?.cartList.value = carts.filter{ !($0.isOrder ?? true) }
                }, onError: {[weak self] error in
                    self?.cartList.value = []
                }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        } else {
            //Google処理
            AuthDataStore.shared.user.asObservable().subscribe(onNext: {[weak self] user in
                guard let `self` = self, let userId = user?.id else {
                    return
                }
                CartDataStore().whereByUserId(userId).subscribe(onNext: {[weak self] carts in
                    self?.cartList.value = carts.filter{ !($0.isOrder ?? true) }
                    }, onError: {[weak self] error in
                        self?.cartList.value = []
                    }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
                }, onError: { _ in
                    self.cartList.value = []
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        }
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
        
        let timestamp = Int(Date().timeIntervalSince1970)*1000
        let orderMonth = Date().convertFormat("yyyyMM")
        let orderDateStr = Date().convertFormat("yyyyMMdd")
        let orderTimeStr = Date().convertFormat("yyyyMMddHHmm")
        
        guard let cart = carts.atIndex(cnt),
            let cartId = cart.id else {return}
        
        let params: [String: Any] = [
            "user_id": cart.userId ?? "",
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
            "shop_id": cart.shopId ?? "",
            "paid_user_id": "",
            "buyer_id": "",
            "delivered_user_id": ""
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
