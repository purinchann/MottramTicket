//
//  MenuSelectController.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/03.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit
import RxSwift

class MenuSelectController: UIViewController {
    
    @IBOutlet weak var allStackHeight: NSLayoutConstraint!
    @IBOutlet weak var allStackWidth: NSLayoutConstraint!
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemNameJpLabel: UILabel!
    @IBOutlet weak var itemNameEnLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    @IBOutlet weak var sizeSelectCollection: UICollectionView!
    
    var priceAndSizeList: [(size: String, price: String)] = []
    var selectCollectionIndexRow: Int = 99
    var selectedSizeAndPrice: (size: String, price: String)?{
        didSet {
            sizeSelectCollection.reloadData()
        }
    }
    
    var menu: Menu?
    var shop: Shop?
    
    fileprivate let repository = MenuSelectRepository()
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUseCase()
    }
    
    func setupUI() {
        
        sizeSelectCollection.dataSource = self
        sizeSelectCollection.delegate = self
        sizeSelectCollection.register(UINib(nibName: "MenuSelectSizeCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        allStackHeight.constant = ViewUtil.shared.getScreenHeight()
        allStackWidth.constant = ViewUtil.shared.getScreenWidth()
        
        guard let menu = menu else {return}
        
        itemNameJpLabel.text = menu.nameJp ?? ""
        itemNameEnLabel.text = menu.nameEn ?? ""
        
        itemImageView.loadImage(urlString: menu.imageUrl, withLoadingImage: true, completion: {_, _ in})
        
        setSizeAndPrice()
    }
    
    private func setSizeAndPrice() {
        
        guard let sizeAndPriceText = menu?.priceAndSize else {return}
        let split = sizeAndPriceText.split(separator: ",")
        split.forEach({subStr in
            let sizeSub = subStr.prefix(1), priceSub = subStr.suffix(subStr.count - 1)
            let sizeStr = String(sizeSub), priceStr = String(priceSub)
            let sizeAndPrice = (size: sizeStr, price: priceStr)
            priceAndSizeList.append(sizeAndPrice)
        })
        sizeSelectCollection.reloadData()
    }
    
    private func bindUseCase() {
        
        repository.isResult.asObservable().bind{[weak self] isResult in
            guard let `self` = self, let isRes = isResult else {return}
            if !isRes {
                self.toast(message: "カートの追加に失敗しました", callback: {})
                return
            }
            
            self.toast(message: "カートへ追加しました", callback: {
                self.navigationController?.popViewController(animated: true)
            })
        }.disposed(by: disposeBag)
    }
    
    @IBAction func addCartAction(_ sender: UIButton) {
        // 価格が選択されているかチェック
        
        guard let sizeAndPrice = selectedSizeAndPrice,
        let price = Int(sizeAndPrice.price) else {
            toast(message: "サイズを選択してください", callback: {})
            return
        }
        
        guard let menu = menu,
            let _shop = shop,
            let isSoldOut = menu.isSoldOut else {
                toast(message: "すみません！お手数ですが、一度、前画面に戻って選び直してください", callback: {})
                return
        }
        
        if isSoldOut {
            toast(message: "この商品は本日は売り切れた模様です", callback: {})
            return
        }
        
        guard let userId = AuthDataStore.shared.currentUser.value?.id else { return }
        let timestamp = Double(Date().timeIntervalSince1970)*1000
        
        let params: [String: Any] = [
            "user_id": userId,
            "menu_name": menu.nameJp ?? "",
            "price": price,
            "size": sizeAndPrice.size,
            "created_at": timestamp,
            "menu_id": menu.id ?? "",
            "shop_id": _shop.id ?? "",
            "is_order": false
        ]
        repository.createCart(params: params)
    }
}

extension MenuSelectController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return priceAndSizeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MenuSelectSizeCell,
        let sizeAndPrice = priceAndSizeList.atIndex(indexPath.row) else {
            return UICollectionViewCell()
        }
        cell.sizeAndPrice = sizeAndPrice
        let isSelect = selectCollectionIndexRow == indexPath.row
        cell.switchColor(isSelect: isSelect)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ViewUtil.shared.getScreenWidth()/2 - 6.0, height = ViewUtil.shared.getScreenWidth() + 30.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sizeAndPrice = priceAndSizeList.atIndex(indexPath.row) else {return}
        selectCollectionIndexRow = indexPath.row
        itemPriceLabel.text = "\(sizeAndPrice.price)円"
        selectedSizeAndPrice = sizeAndPrice
    }
    
}
