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
    
}
