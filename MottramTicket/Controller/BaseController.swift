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
        createTabBarControllers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func createTabBarControllers() {
        var controllers: [UIViewController] = []
        
//        let controller1 = createController(storyboardName: "NewOrderListController")
//        let tabBarItem1 = UITabBarItem(title: "未到着リスト",
//                                       image: UIImage(named: "home_off"),
//                                       selectedImage: UIImage(named: "home_on"))
//        tabBarItem1.imageInsets = tabBarItemInsets
//        controller1.tabBarItem = tabBarItem1
//        controllers.append(controller1)
//
//        let controller2 = createController(storyboardName: "UndispatchedMenuController")
//        let tabBarItem2 = UITabBarItem(title: "未発送リスト",
//                                       image: UIImage(named: "printer_off"),
//                                       selectedImage: UIImage(named: "printer_on"))
//        tabBarItem2.imageInsets = tabBarItemInsets
//        controller2.tabBarItem = tabBarItem2
//        controllers.append(controller2)
//
//        let controller3 = createController(storyboardName: "AsinSearchController")
//        let tabBarItem3 = UITabBarItem(title: "ASIN 検索&入力",
//                                       image: UIImage(named: "barcode_off"),
//                                       selectedImage: UIImage(named: "barcode_on"))
//        tabBarItem3.imageInsets = tabBarItemInsets
//        controller3.tabBarItem = tabBarItem3
//        controllers.append(controller3)
//
//        setViewControllers(controllers, animated: false)
                //selectedIndex = 1
        selectedIndex = 0
    }
}

extension BaseController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
