//
//  BaseDataStore.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

public protocol BaseDataStore {
    
    var ref: CollectionReference { get }
    var autoIDKey: String { get }
    var path: String { get }
    
    func save(params: [String: Any]) -> Observable<Void>
    func delete(byId id: String) -> Observable<Void>
}

extension BaseDataStore {
    
    public var path: String { return "" }
    
    public var ref: CollectionReference {
        return Firestore.firestore().collection(path)
    }
    
    public var autoIDKey: String {
        return ref.collectionID
    }
    
    public func save(params: [String: Any]) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            var _params = params
            if _params["id"] == nil {
                _params["id"] = self.autoIDKey
            }
            self.ref.document((_params["id"] as! String)).updateData(_params, completion: { error in
                if let _ = error {
                    observer.onError(AppError.generic)
                    return
                }
                observer.onNext(Void())
            })
            return Disposables.create()
        })
    }
    
    public func delete(byId id: String) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            self.ref.document(id).updateData(["id": id], completion: { error in
                if let _ = error {
                    observer.onError(AppError.generic)
                    return
                }
                observer.onNext(Void())
            })
            return Disposables.create()
        })
    }
}

