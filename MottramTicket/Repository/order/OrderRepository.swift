//
//  OrderRepository.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/04.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import RxSwift

class OrderRepository {
    
    var orderList = Variable<[Order]>([])
    private let disposeBag = DisposeBag()
    
    func fetchList() {
        
        if let userId = AuthDataStore.shared.currentUser.value?.id {
            OrderDataStore().whereByUserId(userId).subscribe(onNext: {[weak self] orders in
                self?.orderList.value = orders.filter({order in
                    return !(order.isPaid ?? false) &&
                        !(order.isMake ?? false) &&
                        !(order.isComplete ?? false) &&
                        !(order.isCancel ?? false)
                })
                }, onError: {[weak self] error in
                    self?.orderList.value = []
                }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        } else {
            // Google 処理
            AuthDataStore.shared.user.asObservable().subscribe(onNext: {[weak self] user in
                guard let `self` = self, let userId = user?.id else {
                    return
                }
                OrderDataStore().whereByUserId(userId).subscribe(onNext: {[weak self] orders in
                    self?.orderList.value = orders.filter({order in
                        return !(order.isPaid ?? false) &&
                            !(order.isMake ?? false) &&
                            !(order.isComplete ?? false) &&
                            !(order.isCancel ?? false)
                    })
                    }, onError: {[weak self] error in
                        self?.orderList.value = []
                    }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
            }, onError: { _ in
                self.orderList.value = []
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        }
    }
}
