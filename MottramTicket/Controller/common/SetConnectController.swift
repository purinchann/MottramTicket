//
//  SetConnectController.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/07.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit

class SetConnectController: UIViewController {
    
    override func viewDidLoad() {
        let button = UIBarButtonItem(image: UIImage(named: "setting")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.toSetting(sender:)))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func toSetting(sender: Any) {
        let settingController = createController(storyboardName: "SettingController")
        navigationController?.pushViewController(settingController, animated: true)
    }
}
