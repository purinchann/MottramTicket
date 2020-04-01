//
//  AdController.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/06.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit
import WebKit

class AdController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var urlString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
    }
    
    private func loadWebView() {
        
        guard let url = URL(string: urlString) else {return}
        let request = URLRequest(url: url)
        webView.load(request)
        self.view.addSubview(webView)
    }
}
