//
//  SettingRepository.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/07.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import RxSwift

class SettingRepository {
    
    var shop = Variable<Shop?>(nil)
    var isLogout = Variable<Bool?>(nil)
    
    private let disposeBag = DisposeBag()
    
    func logout() {
        AuthDataStore.shared.logout().subscribe(onCompleted: {
                self.isLogout.value = true
            }, onError: {[weak self] _ in
                self?.isLogout.value = false
        }).disposed(by: disposeBag)
    }
    
    func fetchShop() {
        ShopDataStore().findById(id: "Bhgou5g11hYztxeX2JFz").subscribe(onNext: {[weak self] shop in
                self?.shop.value = shop
            }, onError: {[weak self] _ in
                self?.shop.value = nil
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}
