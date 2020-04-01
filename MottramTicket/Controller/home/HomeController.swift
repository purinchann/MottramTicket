//
//  HomeController.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit
import RxSwift

class HomeController: SetConnectController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var repository: HomeRepository = HomeRepository()
    fileprivate var disposeBag: DisposeBag = DisposeBag()
    
    var ad: Ad?
    var shop: Shop?
    
    var menuList: [Menu] = []
    
    var isReloadSet: (isMenus: Bool, isShop: Bool, isAd: Bool) = (isMenus: false, isShop: false, isAd: false) {
        didSet {
            if (self.isReloadSet.isMenus && self.isReloadSet.isShop && isReloadSet.isAd) {
                isReloadSet = (isMenus: false, isShop: false, isAd: false)
                collectionView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchs()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ホーム"
        setupCollectionView()
        bindUseCase()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func fetchs() {
        repository.fetchAd()
        repository.fetchShop(shopId: "Bhgou5g11hYztxeX2JFz")
        repository.fetchMenuList()
    }
    
    private func bindUseCase() {
        
        repository.ad.asObservable().bind{ [weak self] value in
            guard let `self` = self, let ad = value else {
                return
            }
            self.ad = ad
            self.isReloadSet.isAd = true
        }.disposed(by: disposeBag)
        
        repository.shop.asObservable().bind{ [weak self] value in
            guard let `self` = self, let shop = value else {
                return
            }
            self.shop = shop
            self.isReloadSet.isShop = true
        }.disposed(by: disposeBag)
        
        repository.menuList.asObservable().bind { [weak self] value in
            guard let `self` = self else {return}
            if value.isEmpty {return}
            self.menuList = value.filter({menu in
                let shopNumberStr = menu.handlingShopNumber ?? ""
                return shopNumberStr.contains("4")
            })
            self.isReloadSet.isMenus = true
        }.disposed(by: disposeBag)
    }
    
    
    @IBAction func toMap(_ sender: UIButton) {
        guard let latitudeStr = shop?.latitude,
            let longitudeStr = shop?.longitude,
            let latitude = Double(latitudeStr),
            let longitude = Double(longitudeStr),
            let vc = createController(storyboardName: "MapController") as? MapController else {
                return
        }
        vc.lat = latitude
        vc.lng = longitude
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func toCart(_ sender: UIButton) {
        
        if let tabvc = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController  {
            DispatchQueue.main.async {
                tabvc.selectedIndex = 1
            }
        }
        let vc = createController(storyboardName: "CartController")
        self.tabBarController?.navigationController?.present(vc, animated: true, completion: nil)
    }
}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMenuCell", for: indexPath) as? HomeMenuCell,
        let menu = menuList.atIndex(indexPath.row) else {return UICollectionViewCell()}
        cell.menu = menu
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let menu = menuList.atIndex(indexPath.row),
        let _shop = shop,
        let vc = createController(storyboardName: "MenuSelectController") as? MenuSelectController else {return}
        vc.menu = menu
        vc.shop = _shop
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == "UICollectionElementKindSectionHeader") {
            // header
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeHeaderView", for: indexPath) as? HomeHeaderView else {
                return UICollectionReusableView()
            }
            header.ad = ad
            header.shop = shop
            return header
        } else {
            // footer
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HomeFooterView", for: indexPath)
            return footer
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width = ViewUtil.shared.getScreenWidth()
        let height = width + (width/4)
        return CGSize(width: width, height: height)
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ViewUtil.shared.getScreenWidth()/2 - 6.0, height = ViewUtil.shared.getScreenWidth() + 30.0
        return CGSize(width: width, height: height)
    }
}

extension HomeController: HomeHeaderViewDelegate {
    
    func toAdAction(url: String) {
        
        guard let adVC = createController(storyboardName: "AdController") as? AdController else {
            return
        }
        adVC.urlString = url
        navigationController?.pushViewController(adVC, animated: true)
    }
}
