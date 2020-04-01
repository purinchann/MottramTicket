//
//  AuthDataStore.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa

class AuthDataStore {
    
    static let shared = AuthDataStore()
    final private var disposeBag: DisposeBag = DisposeBag()
    
    lazy var user: Driver<User?> = {
        guard let currentUser = Firebase.Auth.auth().currentUser else {
            return Driver.empty()
        }
        return UserDataStore().find(id: currentUser.uid).asDriver(onErrorJustReturn: nil)
    }()
    
    var currentUser: Variable<User?> = Variable(nil)
    
    func loggedIn(callback: @escaping (Bool) -> Void) {
        Auth.auth().addStateDidChangeListener({ [unowned self] (auth, user) in
            if user != nil {
                self.getUserInfo {
                    callback(true)
                }
            } else {
                callback(false)
            }
        })
    }
    
    func getUserInfo(completed: @escaping (() -> Void)) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        UserDataStore().find(id: currentUser.uid).subscribe(onNext: { (user) in
            self.currentUser.value = user
            completed()
        }, onError: { (error) in
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func createUserInfo(_ uid: String, _ email: String, completed: @escaping (() -> Void)) {
        UserDataStore().add(uid: uid, email: email).subscribe(onNext: {(isRes) in
            completed()
        }, onError: {(error) in
        },onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func login(email: String, password: String) -> Observable<Bool> {
        return self.firebaseEmailLogin(email: email, password: password)
    }
    
    func signup(email: String, password: String) -> Observable<Bool> {
        return self.firebaseEmailSignup(email: email, password: password)
    }
    
    func googleLogin(credential: AuthCredential) -> Observable<Bool>  {
        return self.firebaseGoogleLogin(credential)
    }
    
    func googleSignup(credential: AuthCredential) -> Observable<Bool> {
        return self.firebaseGoogleSignup(credential)
    }
    
    func firebaseEmailLogin(email: String, password: String) -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                guard let _ = result else {
                    observer.onError(AppError.generic)
                    return
                }
                self.getUserInfo {
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        })
    }
    
    func firebaseEmailSignup(email: String, password: String) -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                guard let user = authResult?.user else {
                    observer.onError(AppError.generic)
                    return
                }
                self.createUserInfo(user.uid, user.email ?? "", completed: {
                    observer.onNext(true)
                    observer.onCompleted()
                })
            }
            return Disposables.create()
        })
    }
    
    func firebaseGoogleSignup(_ credential: AuthCredential) -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                guard let user = authResult?.user else {
                    observer.onError(AppError.generic)
                    return
                }
                self.createUserInfo(user.uid, user.email ?? "", completed: {
                    observer.onNext(true)
                    observer.onCompleted()
                })
            }
            return Disposables.create()
        })
    }
    
    func firebaseGoogleLogin(_ credential: AuthCredential) -> Observable<Bool> {
        
        return Observable.create({ (observer) -> Disposable in
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                guard let _ = authResult else {
                    observer.onError(AppError.generic)
                    return
                }
                self.getUserInfo {
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        })
    }
    
    func logout() -> Completable {
        return firebaseLogout()
    }
    
    func firebaseLogout() -> Completable {
        return Completable.create { observer in
            do {
                try Auth.auth().signOut()
                observer(.completed)
            }catch let error {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
}

