//
//  CartTableFooterView.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/04.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit

class CartTableFooterView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var totalItemCountLabel: UILabel!
    @IBOutlet weak var totalItemPriceLabel: UILabel!
    @IBOutlet weak var totalFeeLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    var cartList: [Cart] = [] {
        didSet {
            reload()
        }
    }
    
    var fee: Int = 500
    
    private func reload() {
//        商品合計個数
        totalItemCountLabel.text = "\(cartList.count) 個"
//        商品合計代金
        let totalPrice = cartList.reduce(0, {(res, cart) in
            guard let price = cart.price else {return Int()}
            return res + price
        })
        totalItemPriceLabel.text = "\(totalPrice) 円"
//        モッチャムチケットの合計手数料
        let totalFee = cartList.count * self.fee
        totalFeeLabel.text = "\(totalFee) 円"
//        合計金額
        totalAmountLabel.text = "\(totalPrice + totalFee) 円"
    }
    
    @IBAction func tapOnOrderCreate(_ sender: UIButton) {
        self.notify(CartTableFooterEventView.createOrderActionHandler)
    }
}

enum CartTableFooterEventView: EventView {
    
    case createOrderActionHandler
    
    func notify(to handler: CartTableFooterDelegate) {
        switch self {
        case .createOrderActionHandler: handler.createOrderAction()
        }
    }
}

protocol CartTableFooterDelegate {
    func createOrderAction()
}

