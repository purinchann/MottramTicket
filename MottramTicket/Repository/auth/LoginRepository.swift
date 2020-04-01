//
//  LoginRepository.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import RxSwift

class LoginRepository {
    
    // MARK: - Properties
    let isLogin = Variable<Bool>(false)
    private var disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init() {}
    
    // MARK: - Functions
    func login(_ email: String, _ password: String) {
        AuthDataStore.shared.login(email: email, password: password).subscribe(onNext: {[weak self] res in
            self?.isLogin.value = res
            }, onError: {[weak self] error in
                self?.isLogin.value = false
        }).disposed(by: disposeBag)
    }
    
}
