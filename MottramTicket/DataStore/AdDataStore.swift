//
//  AdDataStore.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/03.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import Firebase
import RxSwift

class AdDataStore: BaseDataStore {
    
    var path: String { return "ads" }
    
    public func find() -> Observable<Ad?> {
        return Observable.create({ (observer) -> Disposable in
            self.ref.document("0").getDocument(completion: { doc, error in
                
                guard let jsonDic = doc?.data() else {
                    observer.onError(AppError.generic)
                    return
                }
                let ad = Ad(dic: jsonDic)
                observer.onNext(ad)
            })
            return Disposables.create()
        })
    }
}
