//
//  CartTableCell.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/04.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit

class CartTableCell: UITableViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemSizeLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    
    var cart: Cart?  {
        didSet {
            reload()
        }
    }
    
    private func reload() {
        guard let cart = self.cart else { return }
        itemNameLabel.text = cart.menuName
        itemSizeLabel.text = "\(cart.size ?? "")サイズ"
        itemPriceLabel.text = "\(cart.price ?? 0)円"
        createTimeLabel.text = "\(Date().elapsedTimeStr(unixtime: Int(cart.createdAt ?? 0)))"
    }
}
