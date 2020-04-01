//
//  ShopDataStore.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import RxSwift
import Firebase

class ShopDataStore: BaseDataStore {
    
    var path: String { return "shops" }
    
    func findById(id: String) -> Observable<Shop> {
        return Observable.create({ (observer) -> Disposable in
            self.ref.document(id).getDocument(completion: { doc, error in
                
                guard let jsonDic = doc?.data() else {
                    observer.onError(AppError.generic)
                    return
                }
                let shop = Shop(dic: jsonDic)
                observer.onNext(shop)
            })
            return Disposables.create()
        })
    }
}
