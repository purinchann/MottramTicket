//
//  MenuSelectRepository.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/03.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import RxSwift

class MenuSelectRepository {
    
    var isResult = Variable<Bool?>(nil)
    private let disposeBag = DisposeBag()
    
    func createCart(params: [String: Any]) {
        CartDataStore().add(params).subscribe(onNext: { [weak self] _ in
            self?.isResult.value = true
            },onError: { [weak self] error in
                self?.isResult.value = false
        }).disposed(by: disposeBag)
    }
}
