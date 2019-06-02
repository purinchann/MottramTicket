//
//  UserDataStore.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

class UserDataStore: BaseDataStore {
    
    var path: String { return "users" }
    
    public func find(id: String) -> Observable<User?> {
        return Observable.create({ (observer) -> Disposable in
            self.ref.document(id).getDocument(completion: { doc, error in
                
                guard let jsonDic = doc?.data() else {
                    observer.onError(AppError.generic)
                    return
                }
                let user = User(dic: jsonDic)
                observer.onNext(user)
            })
            return Disposables.create()
        })
    }
    
    public func add(uid: String, email: String) -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            self.ref.document(uid).setData(["id": uid, "mail": email, "role": 0]) { err in
                 if err != nil {
                    //Error
                    observer.onError(AppError.generic)
                    observer.onNext(false)
                    return
                } else {
                    // Success
                    observer.onNext(true)
                }
            }
            return Disposables.create()
        })
    }
}
