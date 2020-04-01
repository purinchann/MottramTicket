//
//  UIImageView+Ext.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func loadImage(urlString: String?, withLoadingImage: Bool = false, completion: @escaping (UIImage?, Error?) -> Void = { _, _ in }) {
        guard let urlString = urlString else { return }
        guard let url = URL(string: urlString) else { return }
        
        if withLoadingImage {
            self.startLoadingImage()
        }
        
        switch url.scheme {
        case "http", "https":
            self.kf.setImage(with: url) {[weak self] image, error, _, _ in
                completion(image, error)
                if withLoadingImage {
                    self?.stopLoadingImage()
                }
            }
        case "data":
            fileTypeImageLoading(url, cmp: {[weak self] img, err in
                completion(img, err)
                if withLoadingImage {
                    self?.stopLoadingImage()
                }
            })
        default:
            if withLoadingImage {
                self.stopLoadingImage()
            }
            isHidden = true
        }
    }
    
    private var loagingImageTag: Int { return 90487648 }
    
    func startLoadingImage() {
        
        if viewWithTag(loagingImageTag) is UIActivityIndicatorView { return }
        
        let activity = UIActivityIndicatorView(style: .gray)
        activity.tag = loagingImageTag
        addSubview(activity)
        activity.addAnchor(to: self, types: .centerX, .centerY)
        activity.startAnimating()
    }
    
    func fileTypeImageLoading(_ url: URL, cmp: @escaping (UIImage?, Error?) -> Void) {
        do {
            let data = try Data(contentsOf: url)
            image = UIImage(data: data)
            cmp(image, nil)
        } catch let err {
            cmp(nil, err)
        }
    }
    
    func stopLoadingImage() {
        
        guard let activity = viewWithTag(loagingImageTag) as? UIActivityIndicatorView else { return }
        
        activity.removeFromSuperview()
    }
}
