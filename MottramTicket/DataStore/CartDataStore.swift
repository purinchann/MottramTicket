//
//  CartDataStore.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/03.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import RxSwift
import Firebase

class CartDataStore: BaseDataStore {
    
    var path: String { return "carts" }
    
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
    
    func whereByUserId(_ userId: String) -> Observable<[Cart]> {
        
        return Observable.create({ (observer) -> Disposable in
            self.ref.whereField("user_id", isEqualTo: userId).getDocuments(completion: {snapshots, error in
                guard let _snapshots = snapshots else {
                        observer.onError(AppError.generic)
                        return
                }
                let carts = _snapshots.documents.map({ Cart(dic: $0.data()) })
                observer.onNext(carts)
            })
            return Disposables.create()
        })
    }
    
    func delete(_ id: String) -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            self.ref.document(id).delete(completion: { error in
                if error != nil {
                    observer.onError(AppError.generic)
                    return
                }
                observer.onNext(true)
            })
            return Disposables.create()
        })
    }
    
    func updateByIsOrder(_ id: String) -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            self.ref.document(id).updateData(["is_order": true]){ error in
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
}
