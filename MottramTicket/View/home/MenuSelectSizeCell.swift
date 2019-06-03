//
//  MenuSelectSizeCell.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/03.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit

class MenuSelectSizeCell: UICollectionViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var sizeLabel: UILabel!
    
    var sizeAndPrice: (size: String, price: String)? {
        didSet {
            reloadData()
        }
    }
    
    func reloadData() {
        guard let size = sizeAndPrice?.size else {return}
        sizeLabel.text = size
    }
    
    func switchColor(isSelect: Bool) {
        if isSelect {
            sizeLabel.textColor = .white
            baseView.backgroundColor = #colorLiteral(red: 0, green: 0.5137254902, blue: 0.5607843137, alpha: 1)
        } else {
            sizeLabel.textColor = #colorLiteral(red: 0, green: 0.5814838409, blue: 0.6292404532, alpha: 1)
            baseView.backgroundColor = .clear
        }
    }
    
}
