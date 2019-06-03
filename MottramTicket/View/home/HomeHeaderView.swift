//
//  HomeHeaderView.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/03.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit

class HomeHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var currentWaitTimeLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    
    var shop: Shop? {
        didSet {
            loadShop()
        }
    }
    var ad: Ad? {
        didSet {
            loadAd()
        }
    }
    
    private func loadAd () {
        guard let _ad = ad else {return}
        adImageView.loadImage(urlString: _ad.bannarImageUrl, withLoadingImage: true, completion: {_, _ in})
    }
    
    private func loadShop() {
        guard let _shop = shop else {return}
        currentWaitTimeLabel.text = "\(_shop.currentWaitTime ?? 0)分"
        feeLabel.text = "\(_shop.fee ?? 500)円"
    }
    
}
