//
//  FirstRepository.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import RxSwift
import Firebase

class FirstRepository {
    
    let isGoogleAuth = Variable<Bool>(false)
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init() {}
    
    // MARK: - Functions
    
    func googleLogin(credential: AuthCredential) {
        
        AuthDataStore().googleLogin(credential: credential).subscribe(onNext: { [weak self] isRes in
            self?.isGoogleAuth.value = true
        }, onError: { [weak self] error in
            self?.isGoogleAuth.value = false
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func googleSignup(credential: AuthCredential) {
        
        AuthDataStore().googleSignup(credential: credential).subscribe(onNext: { [weak self] isRes in
            self?.isGoogleAuth.value = true
        }, onError: {[weak self] error in
            self?.isGoogleAuth.value = false
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}
