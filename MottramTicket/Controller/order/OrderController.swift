//
//  OrderController.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit
import PagingKit
import RxSwift

class OrderController: UIViewController {
    
    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    
    private var contentControllers: [UIViewController] = []
    
    fileprivate let repository = OrderRepository()
    fileprivate let disposeBag = DisposeBag()
    
    var baseOrderList = Variable<[Order]>([])
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "注文"
        initializerView()
        menuViewController.reloadData()
        contentViewController.reloadData()
        bindUseCase()
        repository.fetchList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PagingMenuViewController {
            menuViewController = vc
            menuViewController.dataSource = self
            menuViewController.delegate = self
        } else if let vc = segue.destination as? PagingContentViewController {
            contentViewController = vc
            contentViewController.dataSource = self
            contentViewController.delegate = self
        }
    }
    
    private func initializerView() {

        menuViewController.register(nib: UINib(nibName: "OrderPageMenuCell", bundle: nil),
                                    forCellWithReuseIdentifier: "cell")
        menuViewController.registerFocusView(nib: UINib(nibName: "MenuFocusView", bundle: nil))
        
        contentControllers.append(createController(storyboardName: "OrderNoPaidController"))
        contentControllers.append(createController(storyboardName: "OrderMakingController"))
        contentControllers.append(createController(storyboardName: "OrderWaitDeliveryController"))
        contentControllers.append(createController(storyboardName: "OrderHistoryController"))
    }
    
    private func bindUseCase() {
        
        repository.orderList.asObservable().bind{[weak self] orders in
            guard let `self` = self else {return}
            if orders.isEmpty {return}
            self.baseOrderList.value = orders
            }.disposed(by: disposeBag)
    }
}

extension OrderController: PagingMenuViewControllerDataSource {
    
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return contentControllers.count
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return ViewUtil.shared.getScreenWidth() / CGFloat(contentControllers.count)
    }
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "cell", for: index as Int) as! OrderPageMenuCell
        switch index {
        case 0:
            cell.titleLabel.text = "未支払い"
        case 1:
            cell.titleLabel.text = "並び中"
        case 2:
            cell.titleLabel.text = "受け取り待ち"
        case 3:
            cell.titleLabel.text = "過去の注文履歴"
        default:
            break
        }
        return cell
    }
    
}

extension OrderController: PagingMenuViewControllerDelegate {
    
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        repository.fetchList()
        contentViewController.scroll(to: page, animated: true)
    }
    
}

extension OrderController: PagingContentViewControllerDataSource {
    
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return contentControllers.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return contentControllers[index]
    }
}

extension OrderController: PagingContentViewControllerDelegate {
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        menuViewController.scroll(index: index, percent: percent, animated: false)
    }
}
