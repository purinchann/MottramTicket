//
//  SignupRepository.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import RxSwift

class SignupRepository {
    
    let isSignup = Variable<Bool>(false)
    private var disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init() {}
    
    // MARK: - Functions
    func signup(_ email: String, _ password: String) {
        AuthDataStore.shared.signup(email: email, password: password).subscribe(onNext: {[weak self] res in
            KeyChain.create(dict: [
                "email": email,
                "password": password
                ])
            self?.isSignup.value = res
            }, onError: {[weak self] error in
                self?.isSignup.value = false
        }).disposed(by: disposeBag)
    }
}
