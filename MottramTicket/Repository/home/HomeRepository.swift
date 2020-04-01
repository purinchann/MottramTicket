//
//  HomeRepository.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/03.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import RxSwift

class HomeRepository {
    
    var ad = Variable<Ad?>(nil)
    var shop = Variable<Shop?>(nil)
    var menuList = Variable<[Menu]>([])
    private var disposeBag = DisposeBag()
    
    init() {}
    
    func fetchAd() {
        
        AdDataStore().find().subscribe(onNext: { [weak self] ad in
            self?.ad.value = ad
        }, onError: { [weak self] error in
            self?.ad.value = nil
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func fetchShop(shopId: String) {
        
        ShopDataStore().findById(id: shopId).subscribe(onNext: {[weak self] shop in
            self?.shop.value = shop
            }, onError: {[weak self] error in
                self?.shop.value = nil
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func fetchMenuList() {
        
        MenuDataStore().findAll().subscribe(onNext: {[weak self] menus in
            self?.menuList.value = menus
            }, onError: {[weak self] error in
                self?.menuList.value = []
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
}
