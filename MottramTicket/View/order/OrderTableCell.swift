//
//  OrderTableCell.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/04.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit

class OrderTableCell: UITableViewCell {
    
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var orderSizeLabel: UILabel!
    @IBOutlet weak var orderPriceLabel: UILabel!
    @IBOutlet weak var orderCreateTimeLabel: UILabel!
    
    var order: Order? {
        didSet {
            reload()
        }
    }
    
    private func reload() {
        
        guard let order = order else {return}
        
        orderNameLabel.text = order.orderName ?? ""
        orderSizeLabel.text = "\(order.size ?? "") サイズ"
        orderPriceLabel.text = "\(order.price ?? 0) 円"
        orderCreateTimeLabel.text = "\(Date().elapsedTimeStr(unixtime: Int(order.updatedAt ?? 0)))"
        
        if (order.isComplete ?? false) {
            self.orderNameLabel.textColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
            self.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        }
    }
}
