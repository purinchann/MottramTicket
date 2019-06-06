//
//  BaseController.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit

class BaseController: UITabBarController {
    
    private let tabBarItemInsets = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if let user = AuthDataStore.shared.currentUser.value {
            let role = user.role ?? 0
            if 0 < role {
                createManagedTabBarControllers()
            } else {
                createTabBarControllers()
            }
        } else {
            createTabBarControllers()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func createTabBarControllers() {
        var controllers: [UIViewController] = []
        
        let controller1 = createController(storyboardName: "HomeController")
        let tabBarItem1 = UITabBarItem(title: "ホーム",
                                       image: UIImage(named: "home_off"),
                                       selectedImage: UIImage(named: "home_on"))
        tabBarItem1.imageInsets = tabBarItemInsets
        controller1.tabBarItem = tabBarItem1
        controllers.append(controller1)

        let controller2 = createController(storyboardName: "CartController")
        let tabBarItem2 = UITabBarItem(title: "カート",
                                       image: UIImage(named: "cart_off"),
                                       selectedImage: UIImage(named: "cart_on"))
        tabBarItem2.imageInsets = tabBarItemInsets
        controller2.tabBarItem = tabBarItem2
        controllers.append(controller2)

        let controller3 = createController(storyboardName: "OrderController")
        let tabBarItem3 = UITabBarItem(title: "注文",
                                       image: UIImage(named: "order_off"),
                                       selectedImage: UIImage(named: "order_on"))
        tabBarItem3.imageInsets = tabBarItemInsets
        controller3.tabBarItem = tabBarItem3
        controllers.append(controller3)
        
        let controller4 = createController(storyboardName: "MessageController")
        let tabBarItem4 = UITabBarItem(title: "通知",
                                       image: UIImage(named: "notification_off"),
                                       selectedImage: UIImage(named: "notification_on"))
        tabBarItem4.imageInsets = tabBarItemInsets
        controller4.tabBarItem = tabBarItem4
        controllers.append(controller4)

        setViewControllers(controllers, animated: false)
        selectedIndex = 1
        selectedIndex = 0
    }
    
    
    private func createManagedTabBarControllers() {
        
        var controllers: [UIViewController] = []
        
        let controller1 = createController(storyboardName: "PurchaseController")
        let tabBarItem1 = UITabBarItem(title: "未購入リスト",
                                       image: UIImage(named: "check_file_off"),
                                       selectedImage: UIImage(named: "check_file_on"))
        tabBarItem1.imageInsets = tabBarItemInsets
        controller1.tabBarItem = tabBarItem1
        controllers.append(controller1)
        
        let controller2 = createController(storyboardName: "RenewalScanController")
        let tabBarItem2 = UITabBarItem(title: "QRスキャン",
                                       image: UIImage(named: "qrcode_off"),
                                       selectedImage: UIImage(named: "qrcode_on"))
        tabBarItem2.imageInsets = tabBarItemInsets
        controller2.tabBarItem = tabBarItem2
        controllers.append(controller2)
        
        setViewControllers(controllers, animated: false)
        selectedIndex = 1
        selectedIndex = 0
    }
}

extension BaseController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
