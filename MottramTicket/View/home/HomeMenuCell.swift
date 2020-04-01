//
//  HomeMenuCell.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/03.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit

class HomeMenuCell: UICollectionViewCell {
    
    @IBOutlet weak var menuImageView: UIImageView!
    
    @IBOutlet weak var menuNameLabel: UILabel!
    
    var menu: Menu? {
        didSet {
            reloadData()
        }
    }
    
    private func reloadData() {
        guard let _menu = menu else {return}
        
        menuNameLabel.text = _menu.nameJp ?? ""
        
        menuImageView.loadImage(urlString: _menu.imageUrl, withLoadingImage: true, completion: { _, _ in})
    }
}
