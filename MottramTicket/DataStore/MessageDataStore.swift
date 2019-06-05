//
//  MessageDataStore.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/05.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import Firebase
import RxSwift

class MessageDataStore: BaseDataStore {
    
    var path: String { return "messages" }
    
    func add(_ params: [String: Any]) -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            let documentID = self.ref.addDocument(data: params){ error in
                if let _ = error {
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
    
    func whereByUserId(_ userId: String) -> Observable<[Message]> {
        
        return Observable.create({ (observer) -> Disposable in
            self.ref.whereField("user_id", isEqualTo: userId).getDocuments(completion: {snapshots, error in
                guard let _snapshots = snapshots else {
                    observer.onError(AppError.generic)
                    return
                }
                let messages = _snapshots.documents.map({ Message(dic: $0.data()) })
                observer.onNext(messages)
            })
            return Disposables.create()
        })
    }
    
    func updateByIsWatch(id: String) -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            self.ref.document(id).updateData(["is_watch": true]){ error in
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
