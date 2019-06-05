//
//  HomeHeaderView.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/03.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit

class HomeHeaderView: UICollectionReusableView, UIGestureRecognizerDelegate {
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTapGesture()
    }
    
    func setupTapGesture() {
        
        let adTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.adTapped(_:)))
        adTapGesture.delegate = self
        adTapGesture.numberOfTapsRequired = 1
        adImageView.isUserInteractionEnabled = true
        adImageView.addGestureRecognizer(adTapGesture)
    }
    
    @objc func adTapped(_ sender: UITapGestureRecognizer) {
        guard let adUrl = ad?.pageUrl else {return}
        notify(HomeHeaderEventView.tapAdHandler(link: adUrl))
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

enum HomeHeaderEventView: EventView {
    
    case tapAdHandler(link: String)
    
    func notify(to handler: HomeHeaderViewDelegate) {
        switch self {
        case let .tapAdHandler(targetLink): handler.toAdAction(url: targetLink)
        }
    }
}

protocol HomeHeaderViewDelegate {
    func toAdAction(url: String)
}
