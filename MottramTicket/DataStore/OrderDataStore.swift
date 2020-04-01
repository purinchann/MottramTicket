//
//  OrderDataStore.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/04.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import RxSwift
import Firebase

class OrderDataStore: BaseDataStore {
    
    var path: String { return "orders" }
    
    func add(_ params: [String: Any]) -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            let documentID = self.ref.addDocument(data: params){ error in
                if let err = error {
                    print(err)
                    observer.onError(AppError.generic)
                    return
                }
                }.documentID
            self.ref.document(documentID).updateData(["id": documentID]){error in
                if let err = error {
                    print(err)
                    observer.onError(AppError.generic)
                } else {
                    observer.onNext(true)
                }
            }
            return Disposables.create()
        })
    }
    
    func whereByUserId(_ userId: String) -> Observable<[Order]> {
        
        return Observable.create({ (observer) -> Disposable in
            self.ref.whereField("user_id", isEqualTo: userId).getDocuments(completion: {snapshots, error in
                guard let _snapshots = snapshots else {
                    observer.onError(AppError.generic)
                    return
                }
                let orders = _snapshots.documents.map({ Order(dic: $0.data()) })
                observer.onNext(orders)
            })
            return Disposables.create()
        })
    }
    
    func update(_ id: String, params: [String: Any]) -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            self.ref.document(id).updateData(params){ error in
                if let err = error {
                    print(err)
                    observer.onError(AppError.generic)
                } else {
                    observer.onNext(true)
                }
            }
            return Disposables.create()
        })
    }
    
    func findById(id: String) -> Observable<Order> {
        return Observable.create({ (observer) -> Disposable in
            self.ref.document(id).getDocument(completion: { doc, error in
                
                guard let jsonDic = doc?.data() else {
                    observer.onError(AppError.generic)
                    return
                }
                let shop = Order(dic: jsonDic)
                observer.onNext(shop)
            })
            return Disposables.create()
        })
    }
    
    func whereByTodayOrder(dateStr: String) -> Observable<[Order]> {
        return Observable.create({ (observer) -> Disposable in
            self.ref.whereField("order_date", isEqualTo: dateStr).getDocuments(completion: { snapshot, error in
                guard let querySnapshot = snapshot else {
                    observer.onError(AppError.generic)
                    return
                }
                let orders = querySnapshot.documents.map({ value in
                    return Order(dic: value.data())
                }).filter({ order in
                    return (order.isPaid ?? false) &&
                        !(order.isMake ?? false) &&
                        !(order.isComplete ?? false) &&
                        !(order.isCancel ?? false)
                })
                observer.onNext(orders)
            })
            return Disposables.create()
        })
    }
}
