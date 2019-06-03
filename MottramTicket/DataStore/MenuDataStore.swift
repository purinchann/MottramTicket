//
//  MenuDataStore.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import RxSwift
import Firebase

class MenuDataStore: BaseDataStore {
    
    var path: String { return "menus" }
    
    func findAll() -> Observable<[Menu]>  {
        return Observable.create({ (observer) -> Disposable in
            self.ref.getDocuments(completion: {docs, error in
                guard let _docs = docs else {
                    observer.onError(AppError.generic)
                    return
                }
                let menus = _docs.documents.map({ doc -> Menu in
                    let jsonDic = doc.data()
                    return Menu(dic: jsonDic)
                })
                observer.onNext(menus)
            })
            return Disposables.create()
        })
    }
}

